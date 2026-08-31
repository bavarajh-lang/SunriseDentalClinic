package model;

public class TreatmentItem {

    private int treatmentItemId;
    private int treatmentRecordId;

    /*
     * Existing dental service use pannina
     * serviceId irukkum.
     *
     * Custom / extra treatment na
     * serviceId null-a irukkalaam.
     */
    private Integer serviceId;

    private String itemName;
    private String description;

    private int quantity;

    private double unitPrice;
    private double lineTotal;


    public TreatmentItem() {
    }


    public TreatmentItem(Integer serviceId,
                         String itemName,
                         String description,
                         int quantity,
                         double unitPrice) {

        this.serviceId = serviceId;
        this.itemName = itemName;
        this.description = description;
        this.quantity = quantity;
        this.unitPrice = unitPrice;

        calculateLineTotal();
    }


    public int getTreatmentItemId() {
        return treatmentItemId;
    }

    public void setTreatmentItemId(int treatmentItemId) {
        this.treatmentItemId = treatmentItemId;
    }


    public int getTreatmentRecordId() {
        return treatmentRecordId;
    }

    public void setTreatmentRecordId(int treatmentRecordId) {
        this.treatmentRecordId = treatmentRecordId;
    }


    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }


    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {

        this.quantity = quantity;

        calculateLineTotal();
    }


    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {

        this.unitPrice = unitPrice;

        calculateLineTotal();
    }


    public double getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(double lineTotal) {
        this.lineTotal = lineTotal;
    }


    public void calculateLineTotal() {

        this.lineTotal =
                this.quantity * this.unitPrice;
    }
}