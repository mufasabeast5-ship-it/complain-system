<?php
require 'db.php';
header('Content-Type: application/json');

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$id = $data['id'] ?? null;
$status = $data['status'] ?? null;

if (!$id || !$status) {
    echo json_encode(['error' => 'Complaint id and new status required']);
    exit;
}

$stmt = $pdo->prepare('UPDATE complaints SET status = ? WHERE id = ?');
if ($stmt->execute([$status, $id])) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['error' => 'Failed to update status']);
}
?>
