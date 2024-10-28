Feature: Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header x-api-key = YjViZWJjMmItM2FlMi00NjA1LWFiYzctNTU4ZTEyODhmNDRm

  @allWorkspaces
  Scenario: Obtener todos los workspaces de una cuenta.
    Given endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    And response should be $.[0].name = wvljmqralyjlt
    * define idworkspace = $.[0].id

  @findWorkspace
  Scenario: Obtener datos de un workspace con ID.
    Given call Clockify-Api.feature@allWorkspaces
    And endpoint /v1/workspaces/{{idworkspace}}
    When execute method GET
    Then the status code should be 200

  @workspaceAdd
  Scenario: Crear un nuevo workspace.
    Given endpoint /v1/workspaces
    And header Content-Type = application/json
    And body jsons/bodies/addWorkspaces.json
    When execute method POST
    Then the status code should be 201
    * define idworkspace = $.id

  @clientAdd
  Scenario: Crear un nuevo cliente.
    Given call Clockify-Api.feature@workspaceAdd
    And endpoint /v1/workspaces/{{idworkspace}}/clients
    And header Content-Type = application/json
    And body jsons/bodies/addClient.json
    When execute method POST
    Then the status code should be 201
    * define idclient = $.id

  @allClients
  Scenario: Obtener todos los clientes en un workspace.
    Given call Clockify-Api.feature@allWorkspaces
    And endpoint /v1/workspaces/{{idworkspace}}/clients
    When execute method GET
    Then the status code should be 200

  @findClient
  Scenario: Buscar cliente por ID.
    Given call Clockify-Api.feature@clientAdd
    And endpoint /v1/workspaces/{{idworkspace}}/clients/{{idclient}}
    When execute method GET
    Then the status code should be 200
    * define idclient = $.id

  @deleteClient
  Scenario: Borrar un cliente en un workspace.
    Given call Clockify-Api.feature@findClient
    Given endpoint /v1/workspaces/{{idworkspace}}/clients/{{idclient}}
    When execute method DELETE
    Then the status code should be 200

  @deletedClient
  Scenario: Validar borrado cliente.
    Given call Clockify-Api.feature@deleteClient
    And endpoint /v1/workspaces/{{idworkspace}}/clients/{{idclient}}
    When execute method GET
    Then the status code should be 400
    And response should be $.message = Client doesn't belong to Workspace

  @projectAdd
  Scenario: Crear un nuevo proyecto.
    Given call Clockify-Api.feature@findWorkspace
    And endpoint /v1/workspaces/{{idworkspace}}/projects
    And header Content-Type = application/json
    And body jsons/bodies/addProject.json
    When execute method POST
    Then the status code should be 201
    * define idproject = $.id

  @findProject
  Scenario: Buscar proyecto por ID.
    Given call Clockify-Api.feature@projectAdd
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    When execute method GET
    Then the status code should be 200

  @projectUpdateName
  Scenario: Editar nombre de un proyecto.
    Given call Clockify-Api.feature@findProject
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    And header Content-Type = application/json
    And body jsons/bodies/editProject.json
    When execute method PUT
    Then the status code should be 200