@clockify @errors @TP8
Feature: Clockify errores

  Background:
    Given base url $(env.base_url_clockify)

    #errores:
  @projectUnauthorized
  Scenario: Validar error 401 - api key invalida.
    Given header x-api-key = ySHNAjBP3kJ73ygcFiBE55xRKLcLiVEjg7j0FexbLyHLW7cBT
    And call Clockify.feature@projectAdd
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    When execute method GET
    Then the status code should be 401

  @projectNotFound
  Scenario: Validar error 404 - proyecto sin workspace.
    Given header x-api-key = YjViZWJjMmItM2FlMi00NjA1LWFiYzctNTU4ZTEyODhmNDRm
    And call Clockify.feature@projectAdd
    And endpoint /v1/workspaces/projects/{{idproject}}
    When execute method GET
    Then the status code should be 404

  @projectBadRequest
  Scenario: Validar eror 400 - id proyecto null.
    Given header x-api-key = YjViZWJjMmItM2FlMi00NjA1LWFiYzctNTU4ZTEyODhmNDRm
    And call Clockify.feature@projectAdd
    And endpoint /v1/workspaces/{{idworkspace}}/projects/null
    When execute method GET
    Then the status code should be 400