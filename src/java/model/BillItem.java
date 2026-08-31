package model;

import java.math.BigDecimal;

public class BillItem {

    private int billItemId;
    private int billId;

    private String itemName;
    private String description;

    private int quantity;

    private BigDecimal unitPrice;
    private BigDecimal lineTotal;


    public BillItem() {

        this.quantity = 1;
        this.unitPrice = BigDecimal.ZERO;
        this.lineTotal = BigDecimal.ZERO;
    }


    public BillItem(String itemName,
                    String description,
                    int quantity,
                    BigDecimal unitPrice) {

        this.itemName = itemName;
        this.description = description;
        this.quantity = quantity;
        this.unitPrice =
                unitPrice != null
                ? unitPrice
                : BigDecimal.ZERO;

        calculateLineTotal();
    }


    public int getBillItemId() {
        return billItemId;
    }

    public void setBillItemId(int billItemId) {
        this.billItemId = billItemId;
    }


    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
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


    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {

        this.unitPrice =
                unitPrice != null
                ? unitPrice
                : BigDecimal.ZERO;

        calculateLineTotal();
    }


    public BigDecimal getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(BigDecimal lineTotal) {

        this.lineTotal =
                lineTotal != null
                ? lineTotal
                : BigDecimal.ZERO;
    }


    public void calculateLineTotal() {

        if (unitPrice == null
                || quantity <= 0) {

            lineTotal =
                    BigDecimal.ZERO;

            return;
        }

        lineTotal =
                unitPrice.multiply(
                        BigDecimal.valueOf(quantity)
                );
    }
}