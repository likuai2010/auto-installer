import java.util.logging.*;

public class InterceptLogManager extends LogManager {
    // 静态初始化块 - 在类加载时执行
    static {
        // 关键步骤：替换默认的LogManager实现
        System.setProperty("java.util.logging.manager", InterceptLogManager.class.getName());
    }

    // 自定义Handler实现
    private static class InterceptHandler extends Handler {
        @Override
        public void publish(LogRecord record) {
            // 在这里实现日志拦截逻辑
            System.out.printf("[拦截日志] %s: %s%n",
                record.getLevel(),
                record.getMessage());

            // 可选：将日志继续传递给其他Handler
            // super.publish(record);
        }

        @Override public void flush() {}
        @Override public void close() throws SecurityException {}
    }

    // 重写getLogger方法
    @Override
    public Logger getLogger(String name) {
        // 1. 先获取原始Logger
        Logger logger = super.getLogger(name);

        // 2. 对新创建的Logger添加拦截逻辑
        if (logger != null && logger.getHandlers().length == 0) {
            // 添加自定义Handler
            logger.addHandler(new InterceptHandler());

            // 禁用父Logger的Handler（避免重复输出）
            logger.setUseParentHandlers(false);
        }

        return logger;
    }
}