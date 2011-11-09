We can build a big fat jar using ant zipfileset task

    <target name="uber" depends="compile" description="creating one big fat jar" >
      <jar id="files" jarfile="${dist.dir}/${ant.project.name}.jar" basedir="${build.dir}">
          <manifest>
            <attribute name="Main-Class" value="${main.class}"/>
          </manifest>
          <zipfileset src="${lib.dir}/commons-cli-1.2.jar"/>
          <zipfileset src="${lib.dir}/jetty-continuation-7.1.6.v20100715.jar"/>
          <zipfileset src="${lib.dir}/jetty-http-7.1.6.v20100715.jar"/>
          <zipfileset src="${lib.dir}/jetty-io-7.1.6.v20100715.jar"/>
          <zipfileset src="${lib.dir}/jetty-server-7.1.6.v20100715.jar"/>
          <zipfileset src="${lib.dir}/jetty-util-7.1.6.v20100715.jar"/>
          <zipfileset src="${lib.dir}/servlet-api-2.5.jar"/>
      </jar>
    </target>

but some jar files may throw `java.lang.SecurityException: Invalid signature file digest for Manifest main attributes`
when repackaged, related [stackoverflow question](http://stackoverflow.com/questions/999489/invalid-signature-file-when-attempting-to-run-a-jar).

We can still make one big fat jar files using [onejar](http://one-jar.sourceforge.net/),
onejar doesn't explode jar files like zipfileset does but it package them in the
distributable jar file, and [JarClassLoader](http://one-jar.cvs.sourceforge.net/one-jar/one-jar/src/com/simontuffs/onejar/JarClassLoader.java?view=markup)
loads classes from jar file inside distributable jar, so we don't have to repackage
(explode and jar) the library jar file as they are included in distributable jar as is.

1. Download onejar ant task [jar file](http://one-jar.sourceforge.net/index.php?page=downloads&file=downloads)

2. Create manifest.mf (or whatever better name you can come up with) file as following-

          C:\Temp\my-test-proj>cat manifest.mf
          One-Jar-Main-Class: my.main.ClassName

3. Update `build.xml`

    3.1 Add following, assuming you have copied `one-jar-ant-task-${one-jar.version}.jar` in `C:/tools/java/onejar`

          <property name="one-jar.dist.dir" value="C:/tools/java/onejar"/>
          <property name="one-jar.version" value="0.97"/>
          <property name="one-jar.ant.jar" value="${one-jar.dist.dir}/one-jar-ant-task-${one-jar.version}.jar"/>
          <taskdef name="one-jar"
              classname="com.simontuffs.onejar.ant.OneJarTask"
              classpath="${one-jar.ant.jar}"
              onerror="report"/>

    3.2 Add following target

          <target name="onejar" depends="compile">
            <one-jar destfile="${dist.dir}/${ant.project.name}.jar" manifest="manifest.mf">
              <main>
                <fileset dir="${build.dir}"/>
              </main>
              <lib>
                <fileset dir="${lib.dir}" includes="*.jar"/>
              </lib>
            </one-jar>
            <!-- if you were to copy bootstrap scripts and config with it
            <copy file="${basedir}/logging.properties" todir="${dist}"/>
            <copy file="${basedir}/dateserver.bat" todir="${dist}"/>
            <copy file="${basedir}/dateserver.sh" todir="${dist}"/>
            <chmod file="${dist}/dateserver.sh" perm="755"/>
            -->
          </target>

run the ant task

          C:\Temp\my-test-proj>ant clean onejar

run one executable jar file

          C:\Temp\my-test-proj\dist>java -jar grep.jar
