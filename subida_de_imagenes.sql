DECLARE  CURSOR CUR_USUARIO IS    
SELECT RUT    
FROM USUARIO;      
V_RUT USUARIO.RUT%TYPE;    
V_BLOB BLOB;  V_BFILE BFILE;    
V_TEST NUMBER; 
V_TEST_RUT USUARIO.RUT%TYPE;
BEGIN   
OPEN CUR_USUARIO;    
LOOP      
FETCH CUR_USUARIO INTO V_RUT;      
EXIT WHEN CUR_USUARIO%NOTFOUND;            
UPDATE USUARIO SET IMAGEN = EMPTY_BLOB()      
WHERE RUT = V_RUT RETURNING IMAGEN INTO V_BLOB;            
BEGIN        
V_BFILE := BFILENAME('DIR_TMP', V_RUT || '.png');        
DBMS_LOB.OPEN(V_BFILE, DBMS_LOB.LOB_READONLY);        
DBMS_LOB.LOADFROMFILE(V_BLOB, V_BFILE, DBMS_LOB.GETLENGTH(V_BFILE));        
DBMS_LOB.CLOSE(V_BFILE);      
EXCEPTION        
WHEN OTHERS THEN          
DBMS_OUTPUT.PUT_LINE('EXCEPCIÓN CONTROLADA, JAJAJA');      
END;            
DBMS_OUTPUT.PUT_LINE(V_RUT);    
END LOOP;  
CLOSE CUR_USUARIO;
EXCEPTION  /*WHEN ZERO_DIVIDE THEN    DBMS_OUTPUT.PUT_LINE('NO SE PUEDE DIVIDIR POR CERO: ' || SQLERRM);  WHEN NO_DATA_FOUND THEN    DBMS_OUTPUT.PUT_LINE('SELECT NO ENCONTRÓ INFORMACIÓN: ' || SQLERRM);  WHEN TOO_MANY_ROWS THEN    DBMS_OUTPUT.PUT_LINE('SELECT DEVOLVIÓ MUCHOS REGISTROS: ' || SQLERRM);*/  
WHEN OTHERS THEN    
DBMS_OUTPUT.PUT_LINE('SE HA PRODUCIDO UN ERROR: ' || SQLERRM);
END;