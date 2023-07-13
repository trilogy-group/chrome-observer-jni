package com.crossover;

import java.util.*;

public class App {

    // Create a flag to indicate the running state of the application
    private static volatile boolean isRunning = true;

    public static void main(String[] args) {
        System.out.println("Starting app...");

        // Create and start the event listening thread
        Thread eventListenerThread = new Thread(new SystemEventListener());
        eventListenerThread.start();

        // Main application loop
        while(isRunning) {
            try {
                Thread.sleep(1000); // Sleep for a bit to reduce CPU usage
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        System.out.println("Stopping app...");
    }

    public static class SystemEventListener implements Runnable {
        @Override
        public void run() {
            ChromeObserver observer = new ChromeObserver();
            Timer timer = new Timer();
            timer.schedule(new TimerTask() {
                @Override
                public void run() {
                }
            }, 0, 1000);

            // Wait until the application is stopped
            while(isRunning) {
                try {
                    Thread.sleep(1000); // Sleep for a bit to reduce CPU usage
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            timer.cancel(); // Cancel the timer when the application stops
        }
    }
}