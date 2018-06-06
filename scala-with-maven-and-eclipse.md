# Scala with Maven and Eclipse

## Create new maven project


    mvn -B archetype:generate \
      -DarchetypeGroupId=org.apache.maven.archetypes \
      -DgroupId=${groupId} -DartifactId=${artifactId}

## Update `pom.xml`

    <project
      xmlns="http://maven.apache.org/POM/4.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
      <modelVersion>4.0.0</modelVersion>

      <groupId>foo.bar</groupId>
      <artifactId>ScalaMavenTestProject</artifactId>
      <packaging>jar</packaging>
      <version>1.0-SNAPSHOT</version>

      <name>ScalaMavenTestProject</name>

      <properties>
        <scala.version>2.11.11</scala.version>
        <akka.version>2.5.1</akka.version>
        <scala-maven-plugin.version>3.2.2</scala-maven-plugin.version>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
      </properties>

      <dependencies>

        <dependency>
          <groupId>org.scala-lang</groupId>
          <artifactId>scala-library</artifactId>
          <version>${scala.version}</version>
        </dependency>

        <dependency>
          <groupId>com.typesafe.akka</groupId>
          <artifactId>akka-actor_2.11</artifactId>
          <version>${akka.version}</version>
        </dependency>
      </dependencies>

      <build>

        <pluginManagement>
          <plugins>
            <plugin>
              <groupId>net.alchim31.maven</groupId>
              <artifactId>scala-maven-plugin</artifactId>
              <version>${scala-maven-plugin.version}</version>
            </plugin>
          </plugins>
        </pluginManagement>

        <plugins>

          <plugin>
            <groupId>net.alchim31.maven</groupId>
            <artifactId>scala-maven-plugin</artifactId>
            <version>${scala-maven-plugin.version}</version>
          </plugin>

          <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>build-helper-maven-plugin</artifactId>
            <executions>
              <execution>
                <id>add-source</id>
                <phase>generate-sources</phase>
                <goals>
                  <goal>add-source</goal>
                </goals>
                <configuration>
                  <sources>
                    <source>src/main/scala</source>
                  </sources>
                </configuration>
              </execution>
              <execution>
                <id>add-test-source</id>
                <phase>generate-sources</phase>
                <goals>
                  <goal>add-test-source</goal>
                </goals>
                <configuration>
                  <sources>
                    <source>src/test/scala</source>
                  </sources>
                </configuration>
              </execution>
            </executions>
          </plugin>
        </plugins>
      </build>
    </project>

## Generate eclipse project

    mvn eclipse:eclipse

## Open project in eclipse

* Right click on the project

        Configure -> Add Scala Nature

