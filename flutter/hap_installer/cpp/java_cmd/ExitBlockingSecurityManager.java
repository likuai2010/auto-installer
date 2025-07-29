import java.security.Permission;

public class ExitBlockingSecurityManager extends SecurityManager {
    private final SecurityManager originalSecurityManager;

    public ExitBlockingSecurityManager() {
        SecurityManager original = System.getSecurityManager();
        this.originalSecurityManager = original;
    }

    @Override
    public void checkExit(int status) {
        throw new SecurityException("System.exit(" + status + ") attempted and blocked");
    }

    @Override
    public void checkPermission(Permission perm) {
        // 允许所有权限，或者可以添加特定限制
        if (originalSecurityManager != null) {
            originalSecurityManager.checkPermission(perm);
        }
    }

    @Override
    public void checkPermission(Permission perm, Object context) {
        if (originalSecurityManager != null) {
            originalSecurityManager.checkPermission(perm, context);
        }
    }
    public static void main(String[] args) {
        // 设置我们的安全管理器
        System.setSecurityManager(new ExitBlockingSecurityManager());
    }
}