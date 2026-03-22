<?php
require 'db.php';
header('Content-Type: application/json');

$user_id = $_GET['user_id'] ?? null;

if (!$user_id) {
    echo json_encode(['error' => 'Missing user_id parameter']);
    exit;
}

$stmt = $pdo->prepare('SELECT * FROM complaints WHERE user_id = ? ORDER BY created_at DESC');
$stmt->execute([$user_id]);
$result = $stmt->fetchAll();

echo json_encode(['success' => true, 'complaints' => $result]);
?>
