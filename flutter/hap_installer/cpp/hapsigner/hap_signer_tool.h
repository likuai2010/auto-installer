#ifdef hap_signer_tool_h
#define hap_signer_tool_h
#ifdef __cplusplus
extern "C"
{
#endif

    int signHap(int argc, const char *argv[]);
    char *unzip(const char *source, const char *fileName, const char *destination);

#ifdef __cplusplus
}
#endif
#endif
