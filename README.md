# rvFit-Backend


Mit dem  **rvfit-backend**-Service werden Reha-Fit-Anträge sowohl als XML-Dokument als auch als Papierantrag verarbeitet. 
Der Service stellt die entsprechenden Funktionalitäten für deas **rvfit-frontend** via 
REST API (Repository [rvfit-api](https://git.service.zd.drv/projects/RVEVO-RVSMFIT/repos/rvfit-api/browse)) bereit.

### Dokumentation
siehe [rvFit-Dokumentation (Dima)](https://rvwiki.drv.drv/spaces/VT15BRVEARTMGMT/pages/502864159/01+RV+Fit+Dokumentation)


### Verantwortliche Teams
- [Team Flash - DiMa](https://rvwiki.drv.drv/pages/viewpage.action?pageId=378704520)
- [Contact us - Mattermost](https://mattermost.rvevo.entw.bund.drv/rvevolution/channels/rv-fit-team-two-face--flash---contact-us)

### Links
- [Dokumentation Umgebungen - DiMa](https://rvwiki.drv.drv/pages/viewpage.action?pageId=618400517)
- [Rollen und Rechtekonzept - DiMa](https://rvwiki.drv.drv/spaces/VT15BRVECDP/pages/485827254/Fit+RV+Fit+Rollen-+und+Rechtekonzept)
- [Dokumentation technische Schulden - DiMa](https://rvwiki.drv.drv/display/VT15BRVEARTMGMT/Technische+Schulden+Ist-Zustand+RV+Fit)
- [Templates Release-Repository](https://git.service.zd.drv/projects/RVEVO-RVSMFIT/repos/rvsm-2fa-43-fit-release/browse/rvfit-backend/templates)
- [Environment-Variablen](https://git.service.zd.drv/projects/RVEVO-RVSMFIT/repos/rvsm-2fa-43-fit-environment/browse)
- [ArgoCD Backend - dev1-dev](https://gitops-dev1.apps.os-evo.entw.bund.drv/applications/rvevo-infra-gitops-stage-dev1/team-rvfit-dev1-dev-be)
- [Sonarqube](https://sonarqube.rvevo.entw.bund.drv/dashboard?id=rvevo-rvsmfit%3Arvfit-backend&codeScope=new)
- [Agile Hive Team Flash](https://jira.service.zd.drv/projects/EVORVF1?selectedItem=net.seibertmedia.agilehive.agile-hive-plugin:reports&planningIntervalId=368)

--------------------
## Branching
### Shared-Umgebung
Um eine Entwicklung zu testen existieren die Umgebung shared1 - shared5.

Beispiel: Endet ein Branchnamen mit **-shared1** wird dieser automatisch in die Umgebung **shared1** deployt und kann dort getestet werden.

### Tagging
Um den Stand von DEV auf höhere Umgebungen zu heben wird ein release-Branch und Tags genutzt.

- Soll ein gewisser Entwicklungsstand vom Branch **dev** auf die höheren Umgebungen kommen, wird davon ein Branch **release/X.Y.Z** (X.Y.Z ist die neue Release-Nr.)
abgezweigt und mit **X.Y.Z-SNAPSHOT** getaggt. Damit kann dann auf der **ARTIx-SNAPSHOT**-Umgebung ein Smoketest 
durchgführt werden.

- War der Test erfolgreich, erhält dieser Commit einen weiteren Tag **X.Y.Z-RCn** (n ist eine fortlaufende Nr.) und kann dann auf 
**ARTIx-PRERELEASE** benutzt werden.

- Um auf **ARTIx-RELEASE** übernommen zu werden muss der Tag **X.Y.Z** vergeben werden.

In der Datei **pipeline.yaml** im root-Verzeichnis sind die Regeln hinterlegt wann welcher Commit auf welcher Umgebung deployt wird.

---------------------
## Anwendung starten und testen

### Anwendung lokal starten
Initial sollten die Dependencies im lokalen Repository aktualisert und die Anwendung compiliert werden.
```
mvn -U verify
```
Als Vorbereitung für den lokalen Start wird noch die Verbindung zu einer Queue benötigt.
Dazu kann lokal ein Artemis gestartet werden der die Queue zur Verfügung stellt.
Unter https://git.service.zd.drv/projects/RVEVO-RVSMNZV/repos/x-force-dev-intern/browse/lokaler_betrieb/artemis
ist ein fertiger Artemis der lokal gestartet werden kann.

Zum lokalen Test kann auch der Test-Data-Service lokal gestartet werden.

Die Anwendung kann mit **mvn quarkus:dev** gestartet werden. Mit der Swager-UI 
[http://localhost:8080/q/swagger-ui](http://localhost:8080/q/swagger-ui) 
können die Endpunkte benutzt werden. 

### Anwendung testen
Die JUNIT-Tests werden mit dem folgenden Befehl gestartet
```
mvn test
```

-----------------------
## Konfiguration

### Entwicklungsrechner vorbereiten
Auf den folgenden Seiten sind die notwendigen Schritte beschreiben um einen arbeitsfähigen Entwicklungsrechner einzurichten:
- [Link-Sammlung zu Installation und Einrichtung](https://rvwiki.drv.drv/spaces/VT15BRVECDP/pages/360781019/Einrichten+der+Entwicklungsumgebung)
- [Einrichten des Zugriff auf das ZAR-Maven-Repository](https://rvwiki.drv.drv/spaces/VT15BRVECDP/pages/375977514/FAQ+-+Wie+richte+ich+meinen+Zugriff+auf+das+ZAR-Maven-Repository+ein)
- [Einrichten SSH-Schlüssel](https://rvwiki.drv.drv/pages/viewpage.action?pageId=307951948#Git/Branching/PullRequest/ReviewGuideline-EinrichteneinesSSH-Schl%C3%BCssels).

### Konfiguration-Messagebroker

| Name                                            | Parameter                                                                      |
|:------------------------------------------------|:-------------------------------------------------------------------------------|
| **Zugangsdaten für den Message Broker**         | quarkus.artemis.url<br/>quarkus.artemis.username<br/>quarkus.artemis.password  |
| **Name der Queue für empfangene eAnträge**      | rvfit.queue.spoc.newantrag                                                     |
| **Name der Queue für die eAnträge Bestätigung** | rvfit.queue.spoc.bestaetigeantrag                                              |
| **Url für den SPoC Nutzdaten Service**          | quarkus.rest-client.spoc-nutzdaten.url                                         |
| **Url für den SPoC für die Rückmeldung**        | rvfit-spoc-url                                                                 |

Alle weiteren für den Start notwendigen Parameter sind in der **application.properties** zu finden.

### Service konfigurieren

Für den Lauf unter der DEV-Umgebung sind erweiterte bzw. geänderte Einstellungen in **application-dev.properties** aufgeführt.

### Datenbankversioniereung
Die Datenbankversionierung erfolgt mittels **Liquibase** und wird bei jedem Start des Services geprüft und ausgeführt.

Die Datenbankskripte sind abgelegt unter **src/main/resources/db/changelog**.

Liquibase-Dokumentation: [Liquibase Reference Guide](https://docs.liquibase.com/reference-guide)

------------------------
## Arbeiten mit GIT
Unter [Versionsverwaltung mit git](https://rvwiki.drv.drv/spaces/VT15BRVECDP/pages/307951948/Versionsverwaltung+mit+Git+und+Branching+Guidelines) wird
die Einrichtung von git als auch die Vorgaben für Branchnahmen und Commmit-Messages erläutert.

### Repository klonen
Zum Klonen des Repositories kann die Clone-URL kopiert werden, die unter dem Aktionsbutton *Klonen* zu finden ist.
Auf dem GIT-Client wird dann der folgende Befehl ausegführt:
```
git clone ssh://git@git.service.zd.drv:7999/rvevo-rvsmfit/rvfit-backend.git
```

### Branch aktualisieren und pushen
Zum Aktualisieren des Branches wird **rebase** benutzt, es darf kein **merge** verwendet werden. Der Push muss mit der Option **-f (--force)** durchgeführt werden.
```
git rebase origin/dev
git push -f
```


