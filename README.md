# Programming Project

## Description

Communication between users and LINUX/UNIX systems is done through the command interpreter or Shell, which is not only a powerful but also a flexible programming language. Creating scripts to facilitate administration, management, installation, control, monitoring, searching, data processing, and a lot more is common and provides great performance.

## Objective

To develop a document manager that enables the organization and identification of documents associated with clients of a tax and labor consulting firm. The GesDoc application will start and ask for user login and password, which will be verified in the Fusuarios file to ensure the provided information is correct.

The following files and the particularities of those fields that need to be described will be described below.

1. `Fusuarios` has the following format:
login:clave
- login: identifier of a company user who can operate with the application.
- clave: user access password.

2. `Fclientes` has the following format:
id_cliente:nombre:apellidos:dirección:ciudad:provincia:país:dni:teléfono:carpetadoc:activo
- id_cliente: uniquely identifies the client, is numeric and is automatically assigned by adding 1 to the highest identifier already incorporated. It cannot be modified.
- The rest of the fields are alphanumeric providing information about each client.
- carpetadoc: contains the name of the directory associated with each client. The name is automatically assigned and will be formed with the user identifier, underscore and the string "Doc". For example, for client 10 the directory name will be 10_Doc. The client document folders will be located in the application directory and within the AreaCli directory. If at startup the AreaCli directory does not exist, it must be created.
- activo: automatically assigned when registering a client with the value S indicating that it is active. This field can only be modified during the process of deregistering a client.

3. `Foperaciones` has the following format:
id_usuario:fecha:hora:operación:id_cliente:id_documento
- id_usuario: identifier of the user who performed the operation
- fecha: date on which the operation was performed.
- hora: time at which the operation was performed.
- operación: code that allows identifying the operation performed
- id_cliente: if the operation is on a particular client, the client identifier will be recorded; if it is several clients, "various" will be noted.
- id_documento: if the operation is on a document of a particular client, the document identifier will be recorded; if it is several clients, "various" will be noted.

4. `Fdocumento` has the following format:
id_cliente:id_documento:descripción:fecha
- id_cliente: identifier of the client to whom the document belongs.
- id_documento: document identifier. It is a numeric value and for each client it will start at 1 and will be automatically assigned (last + 1).
- descripción: gives information about what type of document it is.
- fecha: date on which the document was added to the document manager (automatic).

5. `FpresenDoc` has the following format:
id_usuario:id_cliente:id_documento:id_organismo:motivo_presentación:comunidad_autónoma:población:fecha
- id_usuario: identifier of the user who performed the operation
- id_cliente: identifier of the client to whom the document belongs.
- id_documento: identifier of a client's document that is going to be presented to an organism.
- id_organismo: identifier of the organism before which the document is presented.
- motivo_presentación: brief description of why you are presenting this document.
- comunidad_autónoma: where presentation takes place.
- población: where presentation takes place.
- fecha: presentation date (automatic)

Error control is essential in any program and defines its quality, thus avoiding user dissatisfaction. In this program all cases that may lead to error must be controlled.

