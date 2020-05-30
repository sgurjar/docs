## Project directory structure

````
    src/
      main/
        resources/
        scala/
        java/
      test/
        resources/
        scala/
        java/
    project/
      build.properties
    target/
    build.sbt
````
`project/` directory is for helper objects and one-off plugins. it also contains `build.properties` specifying the SBT version to be used. If version is not available locally, SBT launcher will download it.

`build.sbt` file contains build defination.

## SBT commands
* `sbt`    : starts an interactive SBT shell
* `run`    : runs the main class for the project
* `reload` : reloads the project's build definition
* `compile`: compiles the main sources in `/main/scala/` and `/main/java/` 
* `clean`  : deletes contents of `target/` directory
* `package`: generates the `jar` file for the project
* `test`   : compiles and runs all the tests for the project

## Create new SBT project

````python
@py -x -E %~f0 %*

from __future__ import absolute_import, division, print_function
import sys
import os.path
import datetime

if len(sys.argv) < 2:
  print("usage: {} projectname [--yes]".format(os.path.basename(sys.argv[0])))
  sys.exit(1)

project_name = sys.argv[1]

dry_run=True
if len(sys.argv) > 2 and sys.argv[2]=='--yes':
  dry_run=False

print("creates an SBT project directory '{}' under the current directory {}".format(project_name, os.getcwd()))

#### project dirs
#################
newdirs = [
  'src/main/scala'     ,
  'src/main/java'      ,
  'src/main/resources' ,
  'src/main/config'    ,
  'src/main/filters'   ,
  'src/main/assembly'  ,
  'src/site'           ,
  'src/test/scala'     ,
  'src/test/java'      ,
  'src/test/resources' ,
  'src/test/config'    ,
  'src/test/filters'   ,
  'src/test/assembly'  ,
  'lib'                ,
  'target'             ,
]

#### build.sbt
##############
build_sbt="""\
name         := "{}"
version      := "0.1.0"
scalaVersion := "2.12.10"

libraryDependencies ++= Seq(
  "com.typesafe.scala-logging" %% "scala-logging" % "3.9.2",
  "ch.qos.logback" % "logback-classic" % "1.2.3"
)

scalacOptions ++= Seq(
    "-deprecation",     // emit warning and location for usages of deprecated APIs
    "-unchecked",       // enable additional warnings where generated code depends on assumptions
    "-explaintypes",    // explain type errors in more detail
    "-Ywarn-dead-code", // warn when dead code is identified
    "-Xfatal-warnings"  // fail the compilation if there are any warnings
)
""".format(project_name)

#### .gitignore
###############
gitignore="""\
bin/
target/
build/
.bloop
.metals
.cache
.cache-main
.classpath
.history
.project
.scala_dependencies
.settings
.worksheet
.DS_Store
*.class
*.log
*.iml
*.ipr
*.iws
.idea"""

#### README.md
###############
readme=""

def create_new_dir(newdir):
  if not dry_run:
    os.makedirs(os.path.join(project_name, newdir))
  print("created", newdir)

def create_new_file(filename, text):
  newfile = os.path.join(project_name, filename)
  if not dry_run:
    with open(newfile,'w') as f:
      f.write(text)
  print("created", newfile)


for newdir in newdirs:
  create_new_dir(newdir)

create_new_file('build.sbt' , build_sbt)
create_new_file('.gitignore', gitignore)
create_new_file('README.md' , readme   )

if dry_run:
  print('(DRY RUN use --yes for real)')
  ````
