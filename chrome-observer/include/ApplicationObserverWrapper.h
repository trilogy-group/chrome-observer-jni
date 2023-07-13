//
//  ApplicationObserverWrapper.h
//  chromeobserver
//
//  Created by Raul Guerrero on 10/07/23.
//

#ifndef ApplicationObserverWrapper_h
#define ApplicationObserverWrapper_h

#include <memory>
#include <string>

class ApplicationObserverWrapper {
        public:
        ApplicationObserverWrapper();
        ~ApplicationObserverWrapper();
        void stop();
        static void receivedURL(std::string title, std::string url); // callback function

        private:
        class Impl; // forward declaration
        std::unique_ptr<Impl> impl_;
};

#endif //ApplicationObserverWrapper_h
