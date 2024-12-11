const products = JSON.parse(document.getElementById('productsJson').textContent);

const GST_RATE = 0.18; // 18% GST rate

function addProductRow() {
    const rowId = Date.now();
    const row = `
        <tr id="row-${rowId}">
            <td>
                <select class="form-control" onchange="populateDetails(${rowId})">
                    <option value="">Select Product</option>
                    for (let product in products) {
                        <option value="${product}">${product}</option>
                    }
                </select>
            </td>
            <td><input type="text" class="form-control" id="batch-${rowId}" readonly></td>
            <td><input type="text" class="form-control" id="expiry-${rowId}" readonly></td>
            <td><input type="number" class="form-control" id="quantity-${rowId}" value="1" onchange="updatePrice(${rowId})"></td>
            <td><input type="text" class="form-control" id="price-${rowId}" readonly></td>
            <td><input type="text" class="form-control" id="gst-${rowId}" readonly></td>
            <td><input type="text" class="form-control" id="total-${rowId}" readonly></td>
            <td><button type="button" class="btn btn-remove" onclick="removeProductRow(${rowId})">Remove</button></td>
        </tr>
    `;
    document.getElementById('productRows').insertAdjacentHTML('beforeend', row);
}

function populateDetails(rowId) {
    const product = document.querySelector(`#row-${rowId} select`).value;
    if (product && products[product]) {
        document.getElementById(`batch-${rowId}`).value = products[product].batch;
        document.getElementById(`expiry-${rowId}`).value = products[product].expiry;
        updatePrice(rowId);
    }
}

function updatePrice(rowId) {
    const product = document.querySelector(`#row-${rowId} select`).value;
    if (product && products[product]) {
        const quantity = document.getElementById(`quantity-${rowId}`).value;
        const price = products[product].price * quantity;
        const gst = price * GST_RATE;
        const total = price + gst;
        document.getElementById(`price-${rowId}`).value = price.toFixed(2);
        document.getElementById(`gst-${rowId}`).value = gst.toFixed(2);
        document.getElementById(`total-${rowId}`).value = total.toFixed(2);
        updateTotal();
    }
}

function removeProductRow(rowId) {
    document.getElementById(`row-${rowId}`).remove();
    updateTotal();
}

function updateTotal() {
    let total = 0;
    document.querySelectorAll('tbody tr').forEach(row => {
        const rowTotal = parseFloat(row.querySelector('input[id^="total"]').value) || 0;
        total += rowTotal;
    });
    document.getElementById('totalAmount').textContent = total.toFixed(2);
}

function submitBill() {
    const customerName = document.getElementById('customerName').value;
    const customerAddress = document.getElementById('customerAddress').value;
    const billingDate = document.getElementById('billingDate').value;

    const productsData = [];
    document.querySelectorAll('tbody tr').forEach(row => {
        const product = row.querySelector('select').value;
        const batch = row.querySelector('input[id^="batch"]').value;
        const expiry = row.querySelector('input[id^="expiry"]').value;
        const quantity = row.querySelector('input[id^="quantity"]').value;
        const price = row.querySelector('input[id^="price"]').value;
        const gst = row.querySelector('input[id^="gst"]').value;
        const total = row.querySelector('input[id^="total"]').value;

        productsData.push({ product, batch, expiry, quantity, price, gst, total });
    });

    const billData = {
        customerName,
        customerAddress,
        billingDate,
        products: productsData,
        totalAmount: document.getElementById('totalAmount').textContent
    };

    // AJAX call to save billData to the database
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "save-bill.jsp", true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            alert("Bill submitted successfully!");
        }
    };
    xhr.send(JSON.stringify(billData));
}
