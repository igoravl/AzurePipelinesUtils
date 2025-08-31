---
applyTo: '**'
---

* The run_in_terminal tool sometimes fails to capture the command output. If that happens, use the get_terminal_last_command tool to retrieve the last command output from the terminal. If that fails, ask the user to copy-paste the output from the terminal.
* All strings and comments must be produced in English (en-us), unless otherwise explicitly noted.
* When documenting functions, use the standard advanced function documentation format for the header comment, with all the proper sections (including Examples). Parameters, though, must be generated as inline comments atop the parameter definitions and not be included in the header comment. If the function is using inline-style parameters, replace them with an explicit Param block, with the CmdletBinding attribute included. Parameters should always include the Parameter attribute in their first line, followed by the parameter type and name together in the next line. If a parameter is not mandatory, omit the Mandatory attribute.