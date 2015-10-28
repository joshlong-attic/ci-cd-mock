# Continuous Delivery with Artifactory

## Resolution fo Dependencies

the dependencies are discovered by enabling repositories. NOrmally you'd keep snapshot deps out of the maven build and in `settings.xml` but since we can't easuly change the artifact on the CI/CD sercer, we'll instead keep them _dark_ / inert in the `pom.xml` activated only with a `profile`: `cloudnativejava`. Also: u can sepcify default profile in Intellij in Maven Projects view with checkbox.

We want to configure `deploy` to do something useful and that implies that we need a) a `distributiomManagement` section _and_ appropraite configuration values for the artifactory server. You _could_ keep those users/pws in the `settings.xml`, external to the build but that's also hard to manage. Instead, use JFrog's plugin. It handles deployment _and_ it can reference environment variables (which in turn contain the artifactory credentials). `settings.xml` can't do that. this means i can have one maven pom and change it from one environment to another changing only the environment variables. ALSO, it publishes metadatra called `BuildInfo` which is very useful in manipulating state for the artifact, including custom metadata like "cnj-env: prod" whcih can be used for continious delivery workflows. Another big point is that if you use the regular deployment mechanism with Maven,
it'll deploy every single successful build in a multimodule build, keeping back only the failed ones. This means that you could have a partiaully successful build of a multi-module maven project and only some artifacts deployed. the JFrog plugin gates _all_ of the artifacts' moves to the repository.

Here's what `distributionManagement` _would_ look like if we weren't using the plugin:

```

  <distributionManagement>
    <snapshotRepository>
      <id>cloudnativejava-snapshots</id>
      <name>cloudnativejava-snapshots</name>
      <url>https://cloudnativejava.artifactoryonline.com/cloudnativejava/libs-snapshot-local</url>
    </snapshotRepository>
  </distributionManagement>

```

if you decide to use this same build with multiple CI servers (Travis && Drone.io && Circle CI!), ull need to be able to rely on the various encironment variables when feeding the plugin in pom.xml. JFrog plugin supports piping variables, a la https://www.jfrog.com/confluence/display/RTF/Maven+Artifactory+Plugin

for travis CI, check out http://docs.travis-ci.com/user/languages/java/
