<?php
require_once 'config.php';

// --- PASO 1: CONTROL DE ACCESO ---
if (!isset($_SESSION['user_id']) || !isset($_SESSION['is_admin']) || $_SESSION['is_admin'] != 1) {
    $_SESSION['flash_message'] = ['type' => 'error', 'message' => 'Acceso no autorizado.'];
    header('Location: index.php');
    exit();
}

// --- PASO 2: OBTENER DATOS PARA LOS FORMULARIOS Y EL DASHBOARD ---

// Datos para estadísticas
$stats = [
    'total_sales' => $pdo->query("SELECT SUM(total_amount) FROM orders")->fetchColumn(),
    'total_users' => $pdo->query("SELECT COUNT(*) FROM users")->fetchColumn(),
    'active_packages' => $pdo->query("SELECT COUNT(*) FROM packages WHERE is_active = 1")->fetchColumn(),
    'pending_appointments' => $pdo->query("SELECT COUNT(*) FROM appointments WHERE status = 'PENDIENTE'")->fetchColumn()
];

// Datos para selectores de formularios
$flights = $pdo->query("
    SELECT f.id, f.flight_number, CONCAT(lo.city, ' (', lo.airport_code, ') → ', ld.city, ' (', ld.airport_code, ')') as description
    FROM flights f
    JOIN locations lo ON f.origin_id = lo.id
    JOIN locations ld ON f.destination_id = ld.id
    ORDER BY f.id DESC
")->fetchAll(PDO::FETCH_ASSOC);

$hotels = $pdo->query("
    SELECT h.id, CONCAT(h.name, ' (', l.city, ')') as description
    FROM hotels h
    JOIN locations l ON h.location_id = l.id
    ORDER BY h.name ASC
")->fetchAll(PDO::FETCH_ASSOC);

$locations = $pdo->query("SELECT id, CONCAT(city, ', ', country) as name FROM locations ORDER BY city ASC")->fetchAll(PDO::FETCH_ASSOC);
$suppliers = $pdo->query("SELECT id, name, supplier_type FROM suppliers ORDER BY name ASC")->fetchAll(PDO::FETCH_ASSOC);
$categories = $pdo->query("SELECT id, name FROM categories ORDER BY name ASC")->fetchAll(PDO::FETCH_ASSOC);
$tags = $pdo->query("SELECT id, name FROM tags ORDER BY name ASC")->fetchAll(PDO::FETCH_ASSOC);

// Datos para tablas de gestión
$all_packages = $pdo->query("SELECT id, name, is_active, base_price FROM packages ORDER BY id DESC")->fetchAll(PDO::FETCH_ASSOC);
$all_users = $pdo->query("SELECT id, name, email, is_admin, created_at FROM users ORDER BY id DESC")->fetchAll(PDO::FETCH_ASSOC);

// Obtener cantidad de items en el carrito para el Nav
$cart_item_count = 0;
if (isset($_SESSION['user_id'])) {
    $stmt_cart = $pdo->prepare("SELECT COUNT(*) FROM cart WHERE user_id = :user_id");
    $stmt_cart->execute(['user_id' => $_SESSION['user_id']]);
    $cart_item_count = $stmt_cart->fetchColumn();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administrador - Nos Fuimos</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        body { 
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        .glass-form {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }
        .dropdown-menu { 
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(-10px);
            pointer-events: none;
        }
        .dropdown-menu.active {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }
        .sidebar-link.active {
            background: linear-gradient(90deg, #3b82f6 0%, #2563eb 100%);
            color: white;
        }
        .sidebar-link:hover:not(.active) {
            background: rgba(255, 255, 255, 0.1);
        }
        .admin-tab-content {
            display: none;
            animation: fadeIn 0.3s ease-in-out;
        }
        .admin-tab-content.active {
            display: block;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .stat-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }
        .custom-scrollbar::-webkit-scrollbar {
            width: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #3b82f6;
            border-radius: 3px;
        }
        input, select, textarea {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
        }
        input:focus, select:focus, textarea:focus {
            border-color: #3b82f6;
            outline: none;
            box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
        }
    </style>
</head>
<body class="custom-scrollbar">
    <!-- Navbar -->
    <nav class="fixed w-full top-0 z-50 bg-opacity-90 backdrop-blur-lg bg-gray-900 border-b border-white/10">
        <div class="container mx-auto px-4">
            <div class="flex justify-between items-center h-16">
                <a href="index.php" class="font-black text-2xl flex items-center">
                    <span class="text-white">Nos</span>
                    <span class="text-yellow-400">Fuimos</span>
                    <span class="ml-3 text-xs bg-blue-500/30 text-blue-200 px-2 py-1 rounded-full">Admin</span>
                </a>
                
                <div class="flex items-center space-x-4">
                    <!-- Usuario -->
                    <div class="relative" id="user-menu-container">
                        <button id="user-menu-button" 
                                class="flex items-center space-x-3 text-white/90 hover:text-white transition-colors bg-white/5 rounded-full px-4 py-2">
                            <i class="fa-solid fa-circle-user text-xl"></i>
                            <span class="text-sm font-medium"><?php echo htmlspecialchars($_SESSION['user_name']); ?></span>
                            <i class="fa-solid fa-chevron-down text-xs opacity-70"></i>
                        </button>
                        <div id="user-dropdown" class="dropdown-menu absolute right-0 mt-2 w-48 glass-card rounded-xl overflow-hidden">
                            <?php if (isset($_SESSION['is_admin']) && $_SESSION['is_admin'] == 1): ?>
                                <a href="admin_panel.php" class="block px-4 py-2 text-sm text-yellow-400 hover:bg-white/10">
                                    <i class="fa-solid fa-user-shield w-5"></i>
                                    <span class="ml-2">Panel Admin</span>
                                </a>
                            <?php endif; ?>
                            <a href="my_orders.php" class="block px-4 py-2 text-sm text-white hover:bg-white/10">
                                <i class="fa-solid fa-shopping-bag w-5 text-cyan-400"></i>
                                <span class="ml-2">Mis Compras</span>
                            </a>
                            <div class="border-t border-white/10"></div>
                            <a href="logout.php" class="block px-4 py-2 text-sm text-red-400 hover:bg-white/10">
                                <i class="fa-solid fa-arrow-right-from-bracket w-5"></i>
                                <span class="ml-2">Cerrar Sesión</span>
                            </a>
                        </div>
                    </div>
                    <!-- Carrito -->
                    <a href="cart.php" class="text-white hover:text-yellow-400 transition-colors relative">
                        <i class="fa-solid fa-shopping-cart text-2xl"></i>
                        <?php if ($cart_item_count > 0): ?>
                            <span class="absolute -top-2 -right-3 bg-red-500 text-white text-xs font-bold w-5 h-5 flex items-center justify-center rounded-full">
                                <?php echo $cart_item_count; ?>
                            </span>
                        <?php endif; ?>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="flex pt-16">
        <!-- Sidebar -->
        <aside class="w-64 fixed h-full glass-card border-r border-white/10">
            <div class="p-6">
                <h2 class="text-white/80 text-xs font-semibold uppercase tracking-wider mb-6">Menú Principal</h2>
                <nav class="space-y-2">
                    <a href="#" class="sidebar-link active flex items-center px-4 py-3 rounded-lg text-white text-sm font-medium" data-tab="resumen">
                        <i class="fas fa-chart-line w-5"></i>
                        <span class="ml-3">Resumen</span>
                    </a>
                    <a href="#" class="sidebar-link flex items-center px-4 py-3 rounded-lg text-white/70 text-sm font-medium" data-tab="paquetes">
                        <i class="fas fa-box-open w-5"></i>
                        <span class="ml-3">Paquetes</span>
                    </a>
                    <a href="#" class="sidebar-link flex items-center px-4 py-3 rounded-lg text-white/70 text-sm font-medium" data-tab="productos">
                        <i class="fas fa-plane w-5"></i>
                        <span class="ml-3">Productos</span>
                    </a>
                    <a href="#" class="sidebar-link flex items-center px-4 py-3 rounded-lg text-white/70 text-sm font-medium" data-tab="usuarios">
                        <i class="fas fa-users w-5"></i>
                        <span class="ml-3">Usuarios</span>
                    </a>
                    <a href="#" class="sidebar-link flex items-center px-4 py-3 rounded-lg text-white/70 text-sm font-medium" data-tab="config">
                        <i class="fas fa-cogs w-5"></i>
                        <span class="ml-3">Configuración</span>
                    </a>
                </nav>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 ml-64 p-8">
            <!-- Resumen -->
            <div id="tab-resumen" class="admin-tab-content active space-y-8">
                <div class="flex items-center justify-between mb-8">
                    <h1 class="text-3xl font-bold text-white">Dashboard</h1>
                    <div class="flex items-center space-x-4">
                        <span class="text-white/60 text-sm"><?php echo date('d M, Y'); ?></span>
                    </div>
                </div>

                <!-- Stats Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- Ventas -->
                    <div class="stat-card rounded-xl p-6">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-white/60 text-sm font-medium">Ventas Totales</p>
                                <p class="text-2xl font-bold text-white mt-2">
                                    $<?php echo number_format($stats['total_sales'] ?? 0, 2, ',', '.'); ?>
                                </p>
                            </div>
                            <div class="bg-blue-500/20 p-3 rounded-lg">
                                <i class="fas fa-dollar-sign text-blue-400"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Usuarios -->
                    <div class="stat-card rounded-xl p-6">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-white/60 text-sm font-medium">Usuarios</p>
                                <p class="text-2xl font-bold text-white mt-2">
                                    <?php echo number_format($stats['total_users'] ?? 0); ?>
                                </p>
                            </div>
                            <div class="bg-green-500/20 p-3 rounded-lg">
                                <i class="fas fa-users text-green-400"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Paquetes -->
                    <div class="stat-card rounded-xl p-6">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-white/60 text-sm font-medium">Paquetes Activos</p>
                                <p class="text-2xl font-bold text-white mt-2">
                                    <?php echo number_format($stats['active_packages'] ?? 0); ?>
                                </p>
                            </div>
                            <div class="bg-yellow-500/20 p-3 rounded-lg">
                                <i class="fas fa-box-open text-yellow-400"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Turnos -->
                    <div class="stat-card rounded-xl p-6">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-white/60 text-sm font-medium">Turnos Pendientes</p>
                                <p class="text-2xl font-bold text-white mt-2">
                                    <?php echo number_format($stats['pending_appointments'] ?? 0); ?>
                                </p>
                            </div>
                            <div class="bg-pink-500/20 p-3 rounded-lg">
                                <i class="fas fa-calendar-check text-pink-400"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla de Últimos Paquetes -->
                <div class="glass-card rounded-xl p-6 mt-8">
                    <h2 class="text-xl font-semibold text-white mb-6">Últimos Paquetes</h2>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="text-white/60 text-left">
                                    <th class="pb-4 font-medium">ID</th>
                                    <th class="pb-4 font-medium">Nombre</th>
                                    <th class="pb-4 font-medium">Precio</th>
                                    <th class="pb-4 font-medium">Estado</th>
                                    <th class="pb-4 font-medium">Acciones</th>
                                </tr>
                            </thead>
                            <tbody class="text-white/80">
                                <?php foreach(array_slice($all_packages, 0, 5) as $pkg): ?>
                                <tr class="border-t border-white/10">
                                    <td class="py-4"><?php echo $pkg['id']; ?></td>
                                    <td class="py-4"><?php echo htmlspecialchars($pkg['name']); ?></td>
                                    <td class="py-4">$<?php echo number_format($pkg['base_price'], 2); ?></td>
                                    <td class="py-4">
                                        <?php if($pkg['is_active']): ?>
                                            <span class="px-3 py-1 rounded-full text-xs bg-green-500/20 text-green-400">
                                                Activo
                                            </span>
                                        <?php else: ?>
                                            <span class="px-3 py-1 rounded-full text-xs bg-red-500/20 text-red-400">
                                                Inactivo
                                            </span>
                                        <?php endif; ?>
                                    </td>
                                    <td class="py-4">
                                        <div class="flex space-x-3">
                                            <a href="#" class="text-blue-400 hover:text-blue-300">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" class="text-red-400 hover:text-red-300">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Paquetes -->
            <div id="tab-paquetes" class="admin-tab-content">
                <div class="flex items-center justify-between mb-8">
                    <h1 class="text-3xl font-bold text-white">Gestión de Paquetes</h1>
                    <button class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
                        <i class="fas fa-plus mr-2"></i>Nuevo Paquete
                    </button>
                </div>

                <div class="glass-card rounded-xl p-6">
                    <form action="handle_dashboard.php" method="POST" class="space-y-6">
                        <input type="hidden" name="action" value="create_package">
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-white/80 text-sm font-medium mb-2">
                                    Nombre del Paquete
                                </label>
                                <input type="text" name="name" 
                                       class="w-full px-4 py-2 rounded-lg glass-form focus:border-blue-500"
                                       required>
                            </div>
                            <div>
                                <label class="block text-white/80 text-sm font-medium mb-2">
                                    Duración (días)
                                </label>
                                <input type="number" name="duration_days" 
                                       class="w-full px-4 py-2 rounded-lg glass-form focus:border-blue-500"
                                       required>
                            </div>
                            <div>
                                <label class="block text-white/80 text-sm font-medium mb-2">
                                    Ciudad de Salida
                                </label>
                                <input type="text" name="departure_city" 
                                       class="w-full px-4 py-2 rounded-lg glass-form focus:border-blue-500">
                            </div>
                            <div>
                                <label class="block text-white/80 text-sm font-medium mb-2">
                                    Ciudad de Destino
                                </label>
                                <input type="text" name="destination_city" 
                                       class="w-full px-4 py-2 rounded-lg glass-form focus:border-blue-500">
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-white/80 text-sm font-medium mb-2">
                                    Descripción
                                </label>
                                <textarea name="description" rows="3" 
                                          class="w-full px-4 py-2 rounded-lg glass-form focus:border-blue-500"></textarea>
                            </div>
                        </div>

                        <!-- Constructor de Productos -->
                        <div class="border-t border-white/10 pt-6">
                            <h3 class="text-lg font-semibold text-white mb-4">
                                Productos del Paquete
                            </h3>
                            <div id="package-items-container" class="space-y-4"></div>
                            <div class="flex gap-4 mt-4">
                                <select id="item-type-selector" 
                                        class="glass-form rounded-lg px-4 py-2">
                                    <option value="FLIGHT">Vuelo</option>
                                    <option value="HOTEL">Hotel</option>
                                </select>
                                <select id="item-id-selector" 
                                        class="glass-form rounded-lg px-4 py-2 flex-grow"></select>
                                <button type="button" id="add-item-btn" 
                                        class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
                                    <i class="fas fa-plus mr-2"></i>Añadir
                                </button>
                            </div>
                        </div>

                        <!-- Constructor de Itinerario -->
                        <div class="border-t border-white/10 pt-6">
                            <h3 class="text-lg font-semibold text-white mb-4">
                                Itinerario
                            </h3>
                            <div id="itinerary-container" class="space-y-4"></div>
                            <button type="button" id="add-day-btn" 
                                    class="mt-4 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors">
                                <i class="fas fa-calendar-plus mr-2"></i>Añadir Día
                            </button>
                        </div>

                        <div class="flex justify-end pt-6 border-t border-white/10">
                            <button type="submit" 
                                    class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors">
                                Guardar Paquete
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Lista de Paquetes -->
                <div class="glass-card rounded-xl p-6 mt-8">
                    <h2 class="text-xl font-semibold text-white mb-6">Paquetes Existentes</h2>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="text-white/60 text-left">
                                    <th class="pb-4 font-medium">ID</th>
                                    <th class="pb-4 font-medium">Nombre</th>
                                    <th class="pb-4 font-medium">Precio</th>
                                    <th class="pb-4 font-medium">Estado</th>
                                    <th class="pb-4 font-medium">Acciones</th>
                                </tr>
                            </thead>
                            <tbody class="text-white/80">
                                <?php foreach($all_packages as $pkg): ?>
                                <tr class="border-t border-white/10">
                                    <td class="py-4"><?php echo $pkg['id']; ?></td>
                                    <td class="py-4"><?php echo htmlspecialchars($pkg['name']); ?></td>
                                    <td class="py-4">$<?php echo number_format($pkg['base_price'], 2); ?></td>
                                    <td class="py-4">
                                        <?php if($pkg['is_active']): ?>
                                            <span class="px-3 py-1 rounded-full text-xs bg-green-500/20 text-green-400">
                                                Activo
                                            </span>
                                        <?php else: ?>
                                            <span class="px-3 py-1 rounded-full text-xs bg-red-500/20 text-red-400">
                                                Inactivo
                                            </span>
                                        <?php endif; ?>
                                    </td>
                                    <td class="py-4">
                                        <div class="flex space-x-3">
                                            <a href="#" class="text-blue-400 hover:text-blue-300">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" class="text-red-400 hover:text-red-300">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Productos -->
            <div id="tab-productos" class="admin-tab-content">
                <div class="flex items-center justify-between mb-8">
                    <h1 class="text-3xl font-bold text-white">Productos</h1>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- Vuelos -->
                    <div class="glass-card rounded-xl p-6">
                        <h2 class="text-xl font-semibold text-white mb-6">Nuevo Vuelo</h2>
                        <form action="handle_dashboard.php" method="POST">
                            <input type="hidden" name="action" value="create_flight">
                            <button type="submit" 
                                    class="w-full bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
                                <i class="fas fa-plane mr-2"></i>Guardar Vuelo
                            </button>
                        </form>
                    </div>

                    <!-- Hoteles -->
                    <div class="glass-card rounded-xl p-6">
                        <h2 class="text-xl font-semibold text-white mb-6">Nuevo Hotel</h2>
                        <form action="handle_dashboard.php" method="POST">
                            <input type="hidden" name="action" value="create_hotel">
                            <button type="submit" 
                                    class="w-full bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors">
                                <i class="fas fa-hotel mr-2"></i>Guardar Hotel
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Usuarios -->
            <div id="tab-usuarios" class="admin-tab-content">
                <div class="flex items-center justify-between mb-8">
                    <h1 class="text-3xl font-bold text-white">Usuarios</h1>
                </div>

                <div class="glass-card rounded-xl p-6">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="text-white/60 text-left">
                                    <th class="pb-4 font-medium">ID</th>
                                    <th class="pb-4 font-medium">Nombre</th>
                                    <th class="pb-4 font-medium">Email</th>
                                    <th class="pb-4 font-medium">Rol</th>
                                    <th class="pb-4 font-medium">Registro</th>
                                    <th class="pb-4 font-medium">Acciones</th>
                                </tr>
                            </thead>
                            <tbody class="text-white/80">
                                <?php foreach($all_users as $user): ?>
                                <tr class="border-t border-white/10">
                                    <td class="py-4"><?php echo $user['id']; ?></td>
                                    <td class="py-4"><?php echo htmlspecialchars($user['name']); ?></td>
                                    <td class="py-4"><?php echo htmlspecialchars($user['email']); ?></td>
                                    <td class="py-4">
                                        <?php if($user['is_admin']): ?>
                                            <span class="px-3 py-1 rounded-full text-xs bg-yellow-500/20 text-yellow-400">
                                                Admin
                                            </span>
                                        <?php else: ?>
                                            <span class="px-3 py-1 rounded-full text-xs bg-blue-500/20 text-blue-400">
                                                Usuario
                                            </span>
                                        <?php endif; ?>
                                    </td>                                    <td class="py-4"><?php echo date('d/m/Y', strtotime($user['created_at'])); ?></td>
                                    <td class="py-4">
                                        <div class="flex space-x-3">
                                            <a href="#" class="text-blue-400 hover:text-blue-300">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Configuración -->
            <div id="tab-config" class="admin-tab-content">
                <div class="flex items-center justify-between mb-8">
                    <h1 class="text-3xl font-bold text-white">Configuración</h1>
                </div>

                <div class="glass-card rounded-xl p-6">
                    <h2 class="text-xl font-semibold text-white mb-6">Configuración General</h2>
                    <form class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-white/80 text-sm font-medium mb-2">
                                    Nombre del Sitio
                                </label>
                                <input type="text" value="Nos Fuimos" 
                                       class="w-full px-4 py-2 rounded-lg glass-form focus:border-blue-500">
                            </div>
                            <div>
                                <label class="block text-white/80 text-sm font-medium mb-2">
                                    Email de Contacto
                                </label>
                                <input type="email" value="contacto@nosfuimos.com" 
                                       class="w-full px-4 py-2 rounded-lg glass-form focus:border-blue-500">
                            </div>
                        </div>
                        <div class="border-t border-white/10 pt-6">
                            <button type="submit" 
                                    class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors">
                                Guardar Cambios
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

<script>
    // --- LÓGICA DEL PANEL DE ADMINISTRADOR ---
    document.addEventListener('DOMContentLoaded', function() {
        const sidebarLinks = document.querySelectorAll('.sidebar-link');
        const tabContents = document.querySelectorAll('.admin-tab-content');

        sidebarLinks.forEach(link => {
            link.addEventListener('click', e => {
                e.preventDefault();
                const targetTab = link.getAttribute('data-tab');

                // Actualizar links activos
                sidebarLinks.forEach(l => l.classList.remove('active'));
                link.classList.add('active');

                // Mostrar/ocultar pestañas con animación
                tabContents.forEach(tab => {
                    if (tab.id === 'tab-' + targetTab) {
                        tab.style.animation = 'none';
                        tab.offsetHeight; // Trigger reflow
                        tab.style.animation = null;
                        tab.classList.add('active');
                    } else {
                        tab.classList.remove('active');
                    }
                });
            });
        });

        // --- LÓGICA DEL CONSTRUCTOR DE PAQUETES ---
        const flightsData = <?php echo json_encode($flights); ?>;
        const hotelsData = <?php echo json_encode($hotels); ?>;

        const itemTypeSelector = document.getElementById('item-type-selector');
        const itemIdSelector = document.getElementById('item-id-selector');
        const addItemBtn = document.getElementById('add-item-btn');
        const itemsContainer = document.getElementById('package-items-container');
        let itemIndex = 0;

        function updateItemIdOptions() {
            const selectedType = itemTypeSelector.value;
            const data = selectedType === 'FLIGHT' ? flightsData : hotelsData;
            itemIdSelector.innerHTML = '';
            data.forEach(item => {
                const option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.description;
                itemIdSelector.appendChild(option);
            });
        }
        
        addItemBtn.addEventListener('click', () => {
            const selectedType = itemTypeSelector.value;
            const selectedOption = itemIdSelector.options[itemIdSelector.selectedIndex];
            if (!selectedOption) return;

            const selectedId = selectedOption.value;
            const selectedText = selectedOption.textContent;

            const itemHtml = `
                <div class="flex items-center gap-4 p-4 glass-form rounded-lg" id="item-${itemIndex}">
                    <i class="fas ${selectedType === 'FLIGHT' ? 'fa-plane' : 'fa-bed'} text-white/60"></i>
                    <span class="flex-grow text-white/80">${selectedText}</span>
                    <input type="number" name="items[${itemIndex}][day_number]" 
                           placeholder="Día" class="w-20 px-3 py-1 rounded-lg glass-form text-white">
                    <input type="hidden" name="items[${itemIndex}][item_type]" value="${selectedType}">
                    <input type="hidden" name="items[${itemIndex}][item_id]" value="${selectedId}">
                    <button type="button" class="text-red-400 hover:text-red-300 transition-colors" 
                            onclick="document.getElementById('item-${itemIndex}').remove()">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
            itemsContainer.insertAdjacentHTML('beforeend', itemHtml);
            itemIndex++;
        });

        // --- LÓGICA DEL CONSTRUCTOR DE ITINERARIO ---
        const addDayBtn = document.getElementById('add-day-btn');
        const itineraryContainer = document.getElementById('itinerary-container');
        let dayIndex = 0;

        addDayBtn.addEventListener('click', () => {
            const dayHtml = `
                <div class="glass-form rounded-lg p-4" id="day-${dayIndex}">
                    <div class="flex justify-between items-center mb-4">
                        <h4 class="font-semibold text-white">Día ${dayIndex + 1}</h4>
                        <button type="button" class="text-red-400 hover:text-red-300 transition-colors" 
                                onclick="document.getElementById('day-${dayIndex}').remove()">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                    <input type="hidden" name="itinerary[${dayIndex}][day_number]" value="${dayIndex + 1}">
                    <input type="text" name="itinerary[${dayIndex}][title]" 
                           placeholder="Título del día" class="w-full mb-3 px-4 py-2 rounded-lg glass-form text-white" required>
                    <textarea name="itinerary[${dayIndex}][description]" 
                              placeholder="Descripción de actividades..." rows="3" 
                              class="w-full px-4 py-2 rounded-lg glass-form text-white" required></textarea>
                </div>
            `;
            itineraryContainer.insertAdjacentHTML('beforeend', dayHtml);
            dayIndex++;
        });

        // Inicializar selector de items
        itemTypeSelector.addEventListener('change', updateItemIdOptions);
        updateItemIdOptions();
    });

    // --- LÓGICA DEL MENÚ DE USUARIO ---
    const userMenuButton = document.getElementById('user-menu-button');
    const userDropdown = document.getElementById('user-dropdown');
    
    if (userMenuButton) {
        const userMenuArrow = userMenuButton.querySelector('.fa-chevron-down');

        userMenuButton.addEventListener('click', (event) => {
            event.stopPropagation();
            userDropdown.classList.toggle('active');
            userMenuArrow.style.transform = userDropdown.classList.contains('active') ? 'rotate(180deg)' : 'rotate(0)';
        });

        window.addEventListener('click', () => {
            if (userDropdown.classList.contains('active')) {
                userDropdown.classList.remove('active');
                userMenuArrow.style.transform = 'rotate(0)';
            }
        });
    }
</script>
</body>
</html>