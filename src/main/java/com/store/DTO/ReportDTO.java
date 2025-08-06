package com.store.DTO;

import java.util.Date;

public class ReportDTO {
    private Date start_date;
    private Date end_date;
    private double total;

    public ReportDTO(Date start_date, Date end_date, double total) {
        this.start_date = start_date;
        this.end_date = end_date;
        this.total = total;
    }

    public Date getStart_date() {
        return start_date;
    }

    public void setStart_date(Date start_date) {
        this.start_date = start_date;
    }

    public Date getEnd_date() {
        return end_date;
    }

    public void setEnd_date(Date end_date) {
        this.end_date = end_date;
    }

    public double getTotal() {
        return Math.round(total * 100.0) / 100.0;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}
