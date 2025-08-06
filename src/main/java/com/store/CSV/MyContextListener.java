package com.store.CSV;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class MyContextListener implements ServletContextListener {
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("Web application started");
    }

    public void contextDestroyed(ServletContextEvent event) {
        System.out.println("Web application stopped");
    }
}

