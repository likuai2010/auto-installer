#ifndef hap_signer_tool_h
#define hap_signer_tool_h


int sign_hap(int argc, const char *argv[]);
#ifdef __cplusplus
extern "C"
{
#endif
 
    const char *unzip(const char *source, const char *fileName, const char *destination);

#ifdef __cplusplus
}
#endif
#endif
