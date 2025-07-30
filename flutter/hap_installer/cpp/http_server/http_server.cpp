
#include "napi_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <thread>
#include <sys/socket.h>
#include <netinet/in.h>


#define PORT 8080
#define BUFFER_SIZE 4096

static CallbackData callbackData;

void parse_post_params(const char *request, char *params) {
    const char *content_type = strstr(request, "Content-Type: application/x-www-form-urlencoded");
    if (!content_type) {
        strcpy(params, "No POST data or wrong Content-Type");
        return;
    }

    const char *post_data = strstr(request, "\r\n\r\n");
    if (!post_data) {
        strcpy(params, "Malformed POST request");
        return;
    }
    post_data += 4; // Skip past \r\n\r\n

    // 简单示例：直接复制POST数据（实际应做URL解码等处理）
    strncpy(params, post_data, BUFFER_SIZE - 1);
    params[BUFFER_SIZE - 1] = '\0';
}

void handle_client(int client_socket) {
    char buffer[BUFFER_SIZE] = {0};
    const char *response = "HTTP/1.1 200 OK\r\n"
                     "Content-Type: text/html; charset=UTF-8\r\n"
                     "Connection: close\r\n\r\n"
                     "<html><body><h1>登录成功，请返回</h1></body></html>";
    const char *error = "HTTP/1.1 200 OK\r\n"
                     "Content-Type: text/html; charset=UTF-8\r\n"
                     "Connection: close\r\n\r\n"
                     "<html><body><h1>登录失败，请重新登录</h1></body></html>";
   
    read(client_socket, buffer, BUFFER_SIZE);
    char post_params[BUFFER_SIZE] = {0};
    
    if (strstr(buffer, "POST") != NULL) {
        parse_post_params(buffer, post_params);
        callbackData.message = std::string(post_params);
        write(client_socket, response, strlen(response));
    }else{
        write(client_socket, error, strlen(error));
    }
    // 关闭连接
    close(client_socket);
}

int starHttp(int port){
    int server_fd, client_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    // 创建套接字
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        return -1;
    }
    // 设置套接字选项
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        return -1;
    }
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(port);
    // 绑定套接字到端口
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        return EXIT_FAILURE;
    }
    // 开始监听
    if (listen(server_fd, 3) < 0) {
        return EXIT_FAILURE;
    }
    printf("Server listening on port %d...\n", PORT);
    while (1) {
        // 接受新连接
        if ((client_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
            return EXIT_FAILURE;
        }
        // 处理客户端请求
        handle_client(client_socket);
        break;
    }
    close(server_fd);
    return 0;
}
napi_value HttpServer(napi_env env, napi_callback_info info){

    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);

    int port = napi_to_int(env, args[0]);
    napi_value resourceName;
    napi_create_string_latin1(env, "HttpServer", NAPI_AUTO_LENGTH, &resourceName);
    napi_threadsafe_function tsfn;
    napi_create_threadsafe_function(env, args[1], NULL, resourceName, 0, 1, NULL, NULL, NULL, [](napi_env env, napi_value js_callback, void *context, void *data){
       CallbackData* cd = (CallbackData *)data;
        if (cd == nullptr)
            return ;
        napi_value params[1];
        napi_create_string_utf8(env, cd->message.c_str(),cd->message.size(), &params[0]);
        napi_call_function(env, nullptr, js_callback, 1, params, nullptr);
    }, &tsfn);
    std::thread t([](int port, napi_threadsafe_function tsfn){
        callbackData.result = starHttp(port);
        napi_call_threadsafe_function(tsfn, &callbackData, napi_tsfn_blocking);
    }, port, tsfn);
    t.detach();
    return nullptr;
}
EXTERN_C_START

static napi_value Init(napi_env env, napi_value exports)
{
    
    napi_property_descriptor desc[] = {
        { "HttpServer", nullptr, HttpServer, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}

EXTERN_C_END

static napi_module HttpServerModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "HttpServer",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&HttpServerModule);
}