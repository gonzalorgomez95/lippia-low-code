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
    Given call Clockify.feature@allWorkspaces
    And endpoint /v1/workspaces/{{idworkspace}}
    When execute method GET
    Then the status code should be 200

  @projectAdd
  Scenario: Crear un nuevo proyecto.
    Given call Clockify.feature@findWorkspace
    And endpoint /v1/workspaces/{{idworkspace}}/projects
    And header Content-Type = application/json
    And body jsons/bodies/addProject.json
    When execute method POST
    Then the status code should be 201
    * define idproject = $.id

  @findProject
  Scenario: Buscar proyecto por ID.
    Given call Clockify.feature@projectAdd
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    When execute method GET
    Then the status code should be 200

  @projectUpdateName
  Scenario: Editar nombre de un proyecto.
    Given call Clockify.feature@findProject
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    And header Content-Type = application/json
    And body jsons/bodies/editProject.json
    When execute method PUT
    Then the status code should be 200

  @deleteProject @nofunciona
  Scenario: Borrar un proyecto en un workspace.
    Given call Clockify.feature@findProject
    Given endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    When execute method DELETE
    Then the status code should be 200

  @deletedClient @norpobado
  Scenario: Validar borrado proyecto.
    Given call Clockify.feature@deleteProject
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    When execute method GET
    Then the status code should be 400
    And response should be $.message = Project doesn't belong to Workspace
