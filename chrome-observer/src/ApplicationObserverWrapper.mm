//
//  ApplicationObserverWrapper.mm
//  chromeobserver
//
//  Created by Raul Guerrero on 10/07/23.
//

#import "ApplicationObserver.h"
#include <jni.h>
#include "ApplicationObserverWrapper.h"

// Global references to the JVM and the Java object.
static JavaVM *g_jvm = nullptr;
static jobject g_callbackObject = nullptr;

extern "C" {
JNIEXPORT jlong JNICALL Java_com_crossover_ChromeObserver_init(JNIEnv *env, jobject obj) {
    // Store the JVM.
    env->GetJavaVM(&g_jvm);

    // Store the Java object.
    g_callbackObject = env->NewGlobalRef(obj);

    return reinterpret_cast<jlong>(new ApplicationObserverWrapper());
}

JNIEXPORT void JNICALL Java_com_crossover_ChromeObserver_stop(JNIEnv *, jobject, jlong ptr) {
    ApplicationObserverWrapper *appObserver = reinterpret_cast<ApplicationObserverWrapper *>(ptr);
    appObserver->stop();
}

JNIEXPORT void JNICALL Java_com_crossover_ChromeObserver_destroy(JNIEnv *env, jobject, jlong ptr) {
    ApplicationObserverWrapper *appObserver = reinterpret_cast<ApplicationObserverWrapper *>(ptr);
    delete appObserver;
    env->DeleteGlobalRef(g_callbackObject);
    g_callbackObject = nullptr;
}

void receivedURLCallback(const char *title, const char *url) {
    ApplicationObserverWrapper::receivedURL(std::string(title), std::string(url));
}
}

class ApplicationObserverWrapper::Impl {
public:
    Impl() : observer([[ApplicationObserver alloc] init]) {
        [observer setCallback:receivedURLCallback];
    }

    ~Impl() { [observer release]; }

    void stop() { [observer stop]; }

private:
    ApplicationObserver *observer;
};

ApplicationObserverWrapper::ApplicationObserverWrapper() : impl_(new Impl) {}

ApplicationObserverWrapper::~ApplicationObserverWrapper() = default;

void ApplicationObserverWrapper::stop() {
    impl_->stop();
}

void ApplicationObserverWrapper::receivedURL(std::string title, std::string url) {
    JNIEnv *env;
    JavaVMAttachArgs args;
    args.version = JNI_VERSION_1_6;
    args.name = NULL;
    args.group = NULL;

    jint result = g_jvm->AttachCurrentThread((void **)&env, &args);
    if (result != JNI_OK) {
        // Problem with attaching the JVM, can't proceed.
        NSLog(@"Problem with attaching the JVM, can't proceed.");
        return;
    }

    jclass callbackClass = env->GetObjectClass(g_callbackObject);
    if (!callbackClass) {
        // Can't find the class, can't proceed.
        NSLog(@"Can't find the class, can't proceed.");
        return;
    }

    jmethodID callbackMethod = env->GetMethodID(callbackClass, "receivedURL",
                                                "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!callbackMethod) {
        // Can't find the method, can't proceed.
        NSLog(@"Can't find the method, can't proceed.");
        return;
    }

    jstring jTitle = env->NewStringUTF(title.c_str());
    jstring jUrl = env->NewStringUTF(url.c_str());

    env->CallVoidMethod(g_callbackObject, callbackMethod, jTitle, jUrl);

    g_jvm->DetachCurrentThread();
}