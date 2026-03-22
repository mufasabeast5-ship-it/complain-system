<?php
require 'db.php';
header('Content-Type: application/json');

$stmt = $pdo->query('SELECT id, name, email, role, created_at FROM users ORDER BY created_at DESC');
$result = $stmt->fetchAll();

echo json_encode(['success' => true, 'users' => $result]);
?>
