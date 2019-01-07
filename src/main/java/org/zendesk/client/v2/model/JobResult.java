package org.zendesk.client.v2.model;

public class JobResult {

    private Long id;
    private Long index;
    private JobResultAction action;
    private boolean success = false;
    private String status;
    private String error;
    private String details;

    public JobResult() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getIndex() {
        return index;
    }

    public void setIndex(Long index) {
        this.index = index;
    }

    public JobResultAction getAction() {
        return action;
    }

    public void setAction(JobResultAction action) {
        this.action = action;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getError() {
        return error;
    }

    public void setErrors(String error) {
        this.error = error;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    @Override
    public String toString() {
        return "BulkUpdateResult{" +
                "id=" + id +
                ", index=" + index +
                ", action=" + action +
                ", success=" + success +
                ", status='" + status + '\'' +
                ", error='" + error + '\'' +
                ", details='" + details + '\'' +
                '}';
    }

    public enum JobResultAction {
        update,
        create
    }

}
