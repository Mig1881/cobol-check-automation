#!/bin/bash
# mainframe_operations.sh

# Bucle para ejecutar las pruebas de los 3 programas
for program in NUMBERS EMPPAY DEPTPAY; do
    echo "========================================="
    echo "Running cobolcheck for $program"
    
    # Ejecutamos COBOL Check desde la RAÍZ apuntando al .jar dentro de la carpeta
    java -jar cobol-check/bin/cobol-check-0.2.19.jar -p $program
    
    # Si se ha generado el código con las pruebas inyectadas (CC##99.CBL), lo subimos al Mainframe
    if [ -f "CC##99.CBL" ]; then
        echo "Uploading CC##99.CBL to ${ZOWE_USERNAME}.CBL($program)"
        zowe zos-files upload file-to-data-set "CC##99.CBL" "${ZOWE_USERNAME}.CBL($program)"
    else
        echo "CC##99.CBL not found for $program"
    fi

    # Si existe el JCL correspondiente, lo subimos también (ahora estamos en la misma carpeta)
    if [ -f "${program}.JCL" ]; then
        echo "Uploading ${program}.JCL to ${ZOWE_USERNAME}.JCL($program)"
        zowe zos-files upload file-to-data-set "${program}.JCL" "${ZOWE_USERNAME}.JCL($program)"
    else
        echo "${program}.JCL not found"
    fi
done

echo "========================================="
echo "Mainframe operations completed"