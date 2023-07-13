package com.crossover;

public class ChromeObserver {
    static {
        System.loadLibrary("chromeobserver");
    }

    private long nativeHandle;
    private boolean isRunning;

    private native long init();
    private native void stop();
    public native void destroy();

    public ChromeObserver() {
        nativeHandle = init();
        System.out.println("Started with ID " + nativeHandle);
        isRunning = true;
    }

    public void receivedURL(String title, String url) {
        System.out.println("Title: " + title + ", URL: " + url);
    }

    protected void finalize() throws Throwable {
        System.out.println("destroing...");
        if (isRunning)
            stop();
        destroy();
        super.finalize();
    }
}
