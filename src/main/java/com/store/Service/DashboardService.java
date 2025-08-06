package com.store.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DashboardService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;

    public DashboardService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
    }
}
