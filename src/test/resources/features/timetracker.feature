@timeTracker
Feature: Time tracker.

  Background:
    Given base url $(env.base_url_clockify)
    And header x-api-key = $(env.x_api_key)


  @addTimeEntry
  Scenario Outline: Agregar carga horaria a un proyecto existente exitosamente.
    Given endpoint /v1/workspaces/<workspace>/time-entries
    And header Content-Type = application/json
    And set value <cobro> of key billable in body jsons/bodies/addTimeEntry.json
    And set value <descripcion> of key description in body jsons/bodies/addTimeEntry.json
    And set value <horaFin> of key end in body jsons/bodies/addTimeEntry.json
    And set value <proyecto> of key projectId in body jsons/bodies/addTimeEntry.json
    And set value <horaInicio> of key start in body jsons/bodies/addTimeEntry.json
    When execute method POST
    Then the status code should be 201
    * define idTimeEntry = $.id

    Examples:
      | workspace                | descripcion              | proyecto                 | cobro | horaInicio           | horaFin              |
      | 6706ecdf6568416e5e719e7f | Added by Lippia Low Code | 6717124e4cff4a413d474ab3 | true  | 2024-10-31T09:00:00Z | 2024-10-31T12:00:00Z |


  @getTimeEntry
  Scenario Outline: Consultar horas de un proyecto exitosamente.
    Given call timetracker.feature@addTimeEntry
    And endpoint /v1/workspaces/<workspace>/time-entries/{{idTimeEntry}}
    When execute method GET
    Then the status code should be 200
    * define idTimeEntry = $.id

    Examples:
      | workspace                |
      | 6706ecdf6568416e5e719e7f |


  @updateTimeEntry
  Scenario Outline: Editar campo de una carga horaria exitosamente.
    Given call timetracker.feature@getTimeEntry
    And endpoint /v1/workspaces/<workspace>/time-entries/{{idTimeEntry}}
    And header Content-Type = application/json
    And body jsons/bodies/updateTimeEntry.json
    When execute method PUT
    Then the status code should be 200

    Examples:
      | workspace                |
      | 6706ecdf6568416e5e719e7f |


  @deleteTimeEntry @regresion
  Scenario Outline: Borrar carga horaria registrada exitosamente.
    Given call timetracker.feature@updateTimeEntry
    And endpoint /v1/workspaces/<workspace>/time-entries/{{idTimeEntry}}
    When execute method DELETE
    Then the status code should be 204

    Examples:
      | workspace                |
      | 6706ecdf6568416e5e719e7f |