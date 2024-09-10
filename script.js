document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault();
    window.location.href = 'home.html';
});

document.getElementById('signupForm').addEventListener('submit', function(event) {
    event.preventDefault();
    window.location.href = 'index.html';
});

document.getElementById('purchaseForm').addEventListener('submit', function(event) {
    event.preventDefault();
    document.getElementById('orderMessage').style.display = 'block';
});

document.getElementById('billingForm').addEventListener('submit', function(event) {
    event.preventDefault();
    // You can add additional logic here for redirection
    alert('Billing details saved successfully!');
});
