#!/usr/bin/env node
const { spawn, exec } = require('child_process');
const path = require('path');
const fs = require('fs');

console.log('🚀 Iniciando NutriTrack...');
console.log('='.repeat(50));

const projectPath = __dirname;
console.log(`📁 Directorio del proyecto: ${projectPath}`);

// Verificar archivos necesarios
const pomPath = path.join(projectPath, 'pom.xml');
const packagePath = path.join(projectPath, 'frontend', 'package.json');

if (!fs.existsSync(pomPath)) {
    console.error('❌ Error: No se encontró pom.xml');
    process.exit(1);
}

if (!fs.existsSync(packagePath)) {
    console.error('❌ Error: No se encontró frontend/package.json');
    process.exit(1);
}

console.log('✅ Archivos encontrados correctamente\n');

// Función para verificar si un puerto está en uso
function checkPort(port) {
    return new Promise((resolve) => {
        const command = process.platform === 'win32' 
            ? `netstat -an | findstr :${port}`
            : `lsof -i :${port}`;
        
        exec(command, (error, stdout) => {
            resolve(stdout.trim() !== '');
        });
    });
}

// Función principal
async function startServices() {
    console.log('🔍 Verificando puertos...');
    
    const port8080InUse = await checkPort(8080);
    const port3000InUse = await checkPort(3000);
    
    if (port8080InUse) {
        console.log('⚠️  Puerto 8080 ya está en uso (Backend)');
    } else {
        console.log('✅ Puerto 8080 disponible');
    }
    
    if (port3000InUse) {
        console.log('⚠️  Puerto 3000 ya está en uso (Frontend)');
    } else {
        console.log('✅ Puerto 3000 disponible');
    }
    
    console.log('\n🔄 Iniciando servicios...');
    
    // Iniciar Backend
    console.log('🟦 Iniciando Backend (Spring Boot)...');
    const backend = spawn('mvn', ['spring-boot:run'], {
        cwd: projectPath,
        stdio: 'inherit',
        shell: true,
        detached: true
    });
    
    // Esperar un poco
    await new Promise(resolve => setTimeout(resolve, 3000));
    
    // Iniciar Frontend
    console.log('🟩 Iniciando Frontend (Vue.js + Vite)...');
    const frontend = spawn('npm', ['run', 'dev'], {
        cwd: path.join(projectPath, 'frontend'),
        stdio: 'inherit',
        shell: true,
        detached: true
    });
    
    console.log('\n✅ Servicios iniciándose...');
    console.log('🌐 Frontend: http://localhost:3000');
    console.log('🔧 Backend:  http://localhost:8080');
    console.log('🗄️  H2 Console: http://localhost:8080/h2-console');
    console.log('\n📝 Servicios corriendo en background');
    console.log('⏳ Espera unos segundos para que se inicien completamente');
    
    // Manejar cierre limpio
    process.on('SIGINT', () => {
        console.log('\n🛑 Deteniendo servicios...');
        backend.kill();
        frontend.kill();
        process.exit(0);
    });
}

startServices().catch(console.error);