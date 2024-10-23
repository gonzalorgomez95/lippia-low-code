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

  @workspaceInfo @reutilizacion
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

  @deleteClient
  Scenario: Borrar un cliente en un workspace.
    Given call Clockify-Api.feature@clientAdd
    Given endpoint /v1/workspaces/{{idworkspace}}/clients/{{idclient}}
    When execute method DELETE
    Then the status code should be 200


  @deleteClient @ejemplo
  Scenario: Validar borrado cliente.
    Given call Clockify-Api.feature@deleteClient
    And endpoint /v1/workspaces/{{idworkspace}}/clients/{{idclient}}
    When execute method GET
    Then the status code should be 400
    And response should be $.message = Client doesn't belong to Workspace