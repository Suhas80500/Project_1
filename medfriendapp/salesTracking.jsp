<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Tracking - Medical Shop</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .container {
            margin-top: 50px;
        }
        .table th, .table td {
            text-align: center;
        }
        .card-header {
            background-color: #007bff;
            color: white;
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
            border-radius: 25px;
        }
        .btn-custom:hover {
            background-color: #0056b3;
        }
        .page-title {
            text-align: center;
            font-size: 30px;
            margin-bottom: 20px;
        }
        .table-responsive {
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <div class="container">
        <!-- Page Title -->
        <div class="page-title">
            <h2>Sales Tracking - Medical Shop</h2>
        </div>

        <!-- Overview Section -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Sales Overview</h5>
            </div>
            <div class="card-body">
                <p class="card-text">Here you can track the sales of medicines, view detailed information, and monitor total sales performance.</p>
                <a href="#" class="btn btn-custom">Add New Sale</a>
            </div>
        </div>

        <!-- Sales Data Table -->
        <div class="card">
            <div class="card-header">
                <h5>Sales Details</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>Sale ID</th>
                                <th>Medicine Name</th>
                                <th>Quantity Sold</th>
                                <th>Price</th>
                                <th>Total</th>
                                <th>Sale Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Paracetamol</td>
                                <td>10</td>
                                <td>Rs.1.20</td>
                                <td>Rs.12.00</td>
                                <td>2024-11-30</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Ibuprofen</td>
                                <td>5</td>
                                <td>Rs.1.50</td>
                                <td>Rs.7.50</td>
                                <td>2024-11-29</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Aspirin</td>
                                <td>20</td>
                                <td>Rs.0.80</td>
                                <td>Rs.16.00</td>
                                <td>2024-11-28</td>
                            </tr>
                            <!-- More rows can be added dynamically or fetched from the database -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
