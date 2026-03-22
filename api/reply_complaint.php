<?php
require 'db.php';
header('Content-Type: application/json');

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$id = $data['id'] ?? null;
$reply = $data['reply'] ?? null;

if (!$id || !$reply) {
    echo json_encode(['error' => 'Complaint id and reply text required']);
    exit;
}

$stmt = $pdo->prepare('UPDATE complaints SET reply = ?, status = IF(status = "Pending", "In Progress", status) WHERE id = ?');
if ($stmt->execute([$reply, $id])) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['error' => 'Failed to add reply']);
}
?>
