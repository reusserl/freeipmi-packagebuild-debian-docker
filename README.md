# freeipmi-packagebuild-debian-docker
Build new freeipmi debian packages automatically from git master and publish them with aptly.

*This is really just for easy testing new versions on debian based systems. Use stable versions on production systems!*

1. Git clone

  `git clone git@github.com:reusserl/freeipmi-packagebuild-debian-docker.git`

2. Build image

  `docker build --no-cache=true -t freeipmi-deb-builder freeipmi-packagebuild-debian-docker`

3. Run image

  `docker run -d -p 8080:8080 freeipmi-deb-builder`
  
4. Check if container is running

  ```
  docker ps
  CONTAINER ID        IMAGE                  COMMAND               CREATED              STATUS              PORTS                    NAMES
35a70af86df9        freeipmi-deb-builder   "bash /root/CMD.sh"   About a minute ago   Up About a minute   0.0.0.0:8080->8080/tcp   drunk_rosalind
  ```
5. Check logs or wair a few minutes till the build is finished

  `docker logs -f 35a70af86df9`
  ```
  Local repo freeipmi-testing has been successfully published.
  Please setup your webserver to serve directory '/root/.aptly/public' with autoindexing.
  Now you can add following line to apt sources:
    deb http://your-server/ testing main
  Don't forget to add your GPG key to apt with apt-key.

  You can also use `aptly serve` to publish your repositories over HTTP quickly.
  Serving published repositories, recommended apt sources list:

  # ./testing [amd64] publishes {main: [freeipmi-testing]: Freeipmi Testing Repository (from GIT master)}
  deb http://35a70af86df9:8080/ testing main

  Starting web server at: :8080 (press Ctrl+C to quit)...
  ```
  
6. Check if aptly repository is available

  ```
  curl yourdockerhost.foo.bar:8080
  <pre>
  <a href="pool/">pool/</a>
  <a href="dists/">dists/</a>
  </pre>
  ```
  
7. Create apt sources.list

  ```
  cat > /etc/apt/sources.list.d/freeipmi.list <<'EOF'
  deb http://yourdockerhost.foo.bar:8080 testing main
  EOF
  ```

8. Install freshly built packages

  ```
  apt-get install --allow-unauthenticated -t testing freeipmi
  ```
  
9. Try it!

  ```
  ipmi-sensors --output-sensor-state --interpret-oem-data --ignore-unrecognized-events
  ID   | Name        | Type              | State    | Reading    | Units | Event
  4    | CPU Temp    | OEM Reserved      | Nominal  | N/A        | N/A   | 'Low'
  71   | System Temp | Temperature       | Nominal  | 33.00      | C     | 'OK'
  138  | CPU Vcore   | Voltage           | Nominal  | 1.00       | V     | 'OK'
  205  | CPU DIMM    | Voltage           | Nominal  | 1.51       | V     | 'OK'
  272  | CPU Mem VTT | Voltage           | Nominal  | 0.75       | V     | 'OK'
  339  | +1.1 V      | Voltage           | Nominal  | 1.10       | V     | 'OK'
  406  | +1.8 V      | Voltage           | Nominal  | 1.85       | V     | 'OK'
  473  | +5 V        | Voltage           | Nominal  | 5.12       | V     | 'OK'
  540  | +12 V       | Voltage           | Nominal  | 11.87      | V     | 'OK'
  607  | -12 V       | Voltage           | Nominal  | -11.80     | V     | 'OK'
  674  | HT Voltage  | Voltage           | Nominal  | 1.19       | V     | 'OK'
  741  | +3.3 V      | Voltage           | Nominal  | 3.34       | V     | 'OK'
  808  | +3.3VSB     | Voltage           | Nominal  | 3.24       | V     | 'OK'
  875  | VBAT        | Voltage           | Nominal  | 3.24       | V     | 'OK'
  942  | FAN 1       | Fan               | N/A      | N/A        | RPM   | N/A
  1009 | FAN 2       | Fan               | Nominal  | 4096.00    | RPM   | 'OK'
  1076 | FAN 3       | Fan               | Nominal  | 4096.00    | RPM   | 'OK'
  1143 | FAN 4       | Fan               | Nominal  | 4096.00    | RPM   | 'OK'
  1210 | FAN 5       | Fan               | Nominal  | 3600.00    | RPM   | 'OK'
  1277 | FAN 6       | Fan               | Nominal  | 3600.00    | RPM   | 'OK'
  1344 | Intrusion   | Physical Security | Critical | N/A        | N/A   | 'General Chassis Intrusion'
  1411 | PS Status   | Power Supply      | Nominal  | N/A        | N/A   | 'Presence detected'
  ```
