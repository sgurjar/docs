Using Eclipse to debug application running on remote instance of weblogic
=========================================================================

1. make sure server is not running in *production-mode*, if
   `production-mode-enabled` is true, set it to false.

        $ cd $WL_HOME/user_projects/domains/mydomain/config
        $ grep production-mode-enabled config.xml
            <production-mode-enabled>false</production-mode-enabled>

2. update `setDomainEnv.sh`

        $ cd $WL_HOME/user_projects/domains/mydomain/bin

    add following lines ( I added just above the `while [ $# -gt 0 ]` )

        ## for debug -start
        debugFlag="true"
        export debugFlag
        ## for debug -end

3. stop and start the weblogic server. server should be started with following
   command line parameters

        -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=8453,server=y,suspend=n

    we would need `address=8453` part to figure out the port number debugger is running on.

4. `telnet` to verify that host/port are reachable from the computer eclipse is running.
   If you can't reach host:port, changes you need to make are not covered here. Assuming
   telnet worked, go to next step.

5. in eclipse

        Run -> Debug Configuration...

        Remote Java Application
          Project         : Select the project to debug
          Connection Type : Standart (Socket Attach)
          Host            : remote host weblogic instance is running on
          Port            : address part of cmdline arg, from above example its 8453

        Apply

        Debug

6. Open debug prespective and it should show stack trace of weblogic instance

7. You would need to build the code with debugging info to be able to set breakpoint.

8. Click `disconnect` in `Debug` tab on Remote java application when you are done.

9. __Note__ weblogic let you open only one sessions at a time, so if your debugger
   is connected, any more attempts to open more connections to that host/port will fail,
   that includes telnet too.
