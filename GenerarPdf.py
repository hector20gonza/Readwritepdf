import mysql.connector
import pdfrw
from datetime import date

# Configuración de la conexión a la base de datos
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'ejercicio2'
}
mapeo_nombres = {
    'fecha_peticion': 'Fecha petición',
    'nombre_establecimiento': 'Nombre establecimiento',
    'direccion': 'Dirección',
    'cp': 'CP',
    'localidad': 'Localidad',
    'provincia': 'Provincia',
    'persona_contacto': 'Persona contacto',
    'telefono_contacto': 'Teléfono contacto',
    'email': 'email',
    'sector_actividad': 'Sector actividad',
    'tipo_terminal': 'Tipo de terminal',
    'comision': 'comisión',
    'retorno': 'porcentaje retorno',
    'fondo_inicial': 'Fondo inicial',
    'aportacion': 'Aportacion fondo grupo',
    'metodo_reposicion': 'Método reposición grupo',
    'nombre_empresa': 'Nombre empresa',
    'cif': 'CIF',
    'direccion_fiscal': 'Dirección Fiscal',
    'cp_fiscal': 'CP 2',
    'localidad_fiscal': 'Localidad 2',
    'provincia_fiscal': 'Provincia 2',
    'nombre_administrador': 'Nombre administrador',
    'dni_administrador': 'DNI administrador'
}

# Función para obtener los valores desde la base de datos
def obtener_valores_desde_base_de_datos():
    try:
        # Establecer la conexión a la base de datos
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        # Ejecutar la consulta SQL para obtener los valores de los campos
        query = '''
      SELECT f.fecha_peticion AS `Fecha petición`,
       e.nombre AS `Nombre establecimiento`,
       e.direccion AS `Dirección`,
       e.cp AS `CP`,
       e.localidad AS `Localidad`,
       e.provincia AS `Provincia`,
       e.persona_contacto AS `Persona contacto`,
       e.telefono_contacto AS `Teléfono contacto`,
       e.email AS `email`,
       e.sector_actividad AS `Sector actividad`,
       t.tipo ,
       t.comision AS `comisión`,
       t.retorno AS `porcentaje retorno`,
       fo.valor AS `Fondo inicial`,
       fo.aportacion AS `Aportacion fondo grupo`,
       fo.metodo_reposicion AS `Método reposición grupo`,
       em.nombre AS `Nombre empresa`,
       em.cif AS `CIF`,
       em.direccion_fiscal AS `Dirección Fiscal`,
       em.cp_fiscal AS `CP 2`,
       em.localidad_fiscal AS `Localidad 2`,
       em.provincia_fiscal AS `Provincia 2`,
       em.nombre_administrador AS `Nombre administrador`,
       em.dni_administrador AS `DNI administrador`
FROM formulario AS f
JOIN establecimiento AS e ON f.establecimiento_id = e.id
JOIN terminal AS t ON f.terminal_id = t.id
JOIN fondo AS fo ON f.fondo_id = fo.id
JOIN empresa AS em ON e.id_empresa = em.id
WHERE e.id = 1;
        '''

        cursor.execute(query)

        # Obtener todos los resultados de la consulta
        rows = cursor.fetchall()

        # Cerrar la conexión a la base de datos
        cursor.close()
        connection.close()

        # Obtener los nombres de los campos desde el cursor
        field_names = [desc[0] for desc in cursor.description]

        # Crear una lista de diccionarios con los resultados
        results = []
        for row in rows:
            result_dict = {}
            for i, value in enumerate(row):
                result_dict[field_names[i]] = value
            results.append(result_dict)

        return results
    except mysql.connector.Error as error:
        print(f'Error al obtener los valores desde la base de datos: {error}')
        return ()

# Ruta del formulario PDF original y el formulario PDF llenado
pdf_template_path = 'formulario.pdf'
pdf_output_path = 'formulario_lleno.pdf'

# Cargar el formulario PDF original
template_pdf = pdfrw.PdfReader(pdf_template_path)
template_pdf.Root.AcroForm.update(pdfrw.PdfDict(NeedAppearances=pdfrw.PdfObject('true')))

# Obtener los campos de texto en el formulario PDF
fields = template_pdf.Root.AcroForm.Fields

# Obtener los valores desde la base de datos
values = obtener_valores_desde_base_de_datos()

for field in fields:
    if field['/T']:
        field_name = field['/T'][1:-1]
        if field_name in values[0]:
            value = values[0][field_name]
            if isinstance(value, date):
                value = value.strftime('%Y-%m-%d')
            field.update(pdfrw.PdfDict(V='{}'.format(value)))

# Guardar el formulario PDF llenado en un nuevo archivo
pdfrw.PdfWriter().write(pdf_output_path, template_pdf)

print("Formulario PDF llenado exitosamente.")
for field in fields:
    if field['/T']:
        field_name = field['/T'][1:-1]
        print(field_name)