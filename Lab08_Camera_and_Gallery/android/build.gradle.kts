allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val p = this
    val configureAndroid = {
        if (p.hasProperty("android")) {
            val android = p.extensions.findByName("android")
            if (android != null) {
                try {
                    val setCompileSdk = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType)
                    setCompileSdk.invoke(android, 36)
                } catch (e: Exception) {
                    try {
                        val setCompileSdk = android.javaClass.getMethod("setCompileSdk", java.lang.Integer::class.java)
                        setCompileSdk.invoke(android, 36)
                    } catch (e2: Exception) {
                        // Ignore
                    }
                }
                try {
                    val getNamespace = android.javaClass.getMethod("getNamespace")
                    val currentNamespace = getNamespace.invoke(android)
                    if (currentNamespace == null) {
                        val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                        if (p.name == "gallery_saver") {
                            setNamespace.invoke(android, "carnegietechnologies.gallery_saver")
                        } else {
                            setNamespace.invoke(android, "com.example.${p.name.replace('-', '_')}")
                        }
                    }
                } catch (e: Exception) {
                    // Ignore
                }
                try {
                    val getCompileOptions = android.javaClass.getMethod("getCompileOptions")
                    val compileOptions = getCompileOptions.invoke(android)
                    if (compileOptions != null) {
                        val setSource = compileOptions.javaClass.getMethod("setSourceCompatibility", JavaVersion::class.java)
                        val setTarget = compileOptions.javaClass.getMethod("setTargetCompatibility", JavaVersion::class.java)
                        setSource.invoke(compileOptions, JavaVersion.VERSION_17)
                        setTarget.invoke(compileOptions, JavaVersion.VERSION_17)
                    }
                } catch (e: Exception) {
                    // Ignore
                }
            }
        }
    }
    if (p.state.executed) {
        configureAndroid()
    } else {
        p.afterEvaluate {
            configureAndroid()
        }
    }

    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }

    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
