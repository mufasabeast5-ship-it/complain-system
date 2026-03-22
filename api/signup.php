<?php
require 'db.php';
header('Content-Type: application/json');

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$name = $data['name'] ?? '';
$email = $data['email'] ?? '';
$password = $data['password'] ?? '';
$role = $data['role'] ?? 'user';

if (!$name || !$email || !$password) {
    echo json_encode(['error' => 'All fields required']);
    exit;
}

$stmt = $pdo->prepare('SELECT id FROM users WHERE email = ?');
$stmt->execute([$email]);
if ($stmt->fetch()) {
    echo json_encode(['error' => 'Email already registered']);
    exit;
}

$hash = password_hash($password, PASSWORD_DEFAULT);
$insert = $pdo->prepare('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)');

if ($insert->execute([$name, $email, $hash, $role])) {
    $id = $pdo->lastInsertId();
    $user = ['id' => $id, 'name' => $name, 'email' => $email, 'role' => $role];
    echo json_encode(['success' => true, 'user' => $user]);
} else {
    echo json_encode(['error' => 'Failed to create user']);
}
?>
