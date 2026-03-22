<?php
require 'db.php';
header('Content-Type: application/json');

// Useful for admin dashboard pulling all complaints
$stmt = $pdo->query('SELECT complaints.*, users.name as user_name FROM complaints LEFT JOIN users ON complaints.user_id = users.id ORDER BY complaints.created_at DESC');
$result = $stmt->fetchAll();

echo json_encode(['success' => true, 'complaints' => $result]);
?>
