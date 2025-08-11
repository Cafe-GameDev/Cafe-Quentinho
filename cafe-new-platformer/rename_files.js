const fs = require('fs');
const path = require('path');

function renameFiles(directory) {
    fs.readdir(directory, { withFileTypes: true }, (err, entries) => {
        if (err) {
            console.error(`Erro ao ler o diretório ${directory}:`, err);
            return;
        }

        entries.forEach(entry => {
            const oldPath = path.join(directory, entry.name);
            const newName = entry.name.replace(/ /g, '_'); // Replace all spaces
            const newPath = path.join(directory, newName);

            if (entry.isDirectory()) {
                // Recursively call for subdirectories
                if (entry.name !== '.' && entry.name !== '..') {
                    renameFiles(oldPath);
                }
            } else {
                // It's a file, rename it
                if (entry.name !== newName) {
                    fs.rename(oldPath, newPath, (renameErr) => {
                        if (renameErr) {
                            console.error(`Erro ao renomear ${oldPath} para ${newPath}:`, renameErr);
                        } else {
                            console.log(`Renomeado: ${entry.name} -> ${newName}`);
                        } 
                    });
                }
            }
        });
    });
}

// Set the target directory to the current working directory
const targetDirectory = process.cwd();

console.log(`Iniciando renomeação de arquivos em: ${targetDirectory}`);
renameFiles(targetDirectory);
console.log('Renomeação concluída. Por favor, reinicie o editor da Godot para que as mudanças sejam reconhecidas.');