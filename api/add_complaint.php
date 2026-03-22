<?php
require 'db.php';
header('Content-Type: application/json');

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$userId = $data['user_id'] ?? null;
$title = $data['title'] ?? '';
$desc = $data['description'] ?? '';
$category = $data['category'] ?? 'Other';

if (!$userId || !$title || !$desc) {
    echo json_encode(['error' => 'Missing required fields']);
    exit;
}

$stmt = $pdo->prepare('INSERT INTO complaints (user_id, title, description, category, status) VALUES (?, ?, ?, ?, "Pending")');
if ($stmt->execute([$userId, $title, $desc, $category])) {
    echo json_encode(['success' => true, 'id' => $pdo->lastInsertId()]);
} else {
    echo json_encode(['error' => 'Failed to add complaint']);
}
?>
