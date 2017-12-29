# Kafka Security #

## Authentication ##

### SASL PLAIN ###

#### Config on the Kafka server ####

```
kafka/config$ cat kafka_server_jaas.conf
KafkaServer {
    org.apache.kafka.common.security.plain.PlainLoginModule required
    username="admin"
    password="admin-secret"
    user_admin="admin-secret"
    user_alice="alice-secret"
    user_bob="bob-secret";
};
```

* Here, `username` and `password` is to specify which user will be used for __inter-broker__ authentication.
* And all the users specified with `user_Name` pattern (including `user_admin`), can be used by Kafka clients (producer/consumer).
* __NOTE:__ We must specifiy the user with `username` and `password` with `user_Name` pattern again. In this
  example, we did that with `user_admin`.

##### Set following property on Kafka server JVM #####

```
-Djava.security.auth.login.config=config/kafka_server_jaas.conf
```

One way of doing this is to set `KAFKA_OPTS` environment variable (in your kafka start script (if you have one)).

```
export KAFKA_OPTS="-Djava.security.auth.login.config=config/kafka_server_jaas.conf"
```

##### Add following to `kafka/config/server.properties` #####

```
listeners=SASL_PLAINTEXT://192.168.56.103:9092
advertised.listeners=SASL_PLAINTEXT://192.168.56.103:9092
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN
```

#### Config on the Kafka client (producer/consumer) ####

##### Using external file

This approach allows us to have only one user/password for whole JVM, for every connection made from that JVM to Kafka broker.

```
$cat kafka_client_jaas.conf
KafkaClient {
  org.apache.kafka.common.security.plain.PlainLoginModule required
  username="alice"
  password="alice-secret";
};
```

* Make a _note_ of `;` here, don't mess it up, it wont work.

###### Add following property on Client JVM

```
-Djava.security.auth.login.config=kafka_client_jaas.conf
```

###### Set these two properties to your `KafkaConsumer` and `KafkaProducer`.

```java
//...
p.setProperty("security.protocol", "SASL_PLAINTEXT");
p.setProperty("sasl.mechanism", "PLAIN");
//...

producer = new KafkaProducer<>(p);

consumer = new KafkaConsumer<>(p);
```

##### NOT using external file

If you donot want to creare an external file or want to use multiple
user/password for multiple connections to kafka broker from same JVM,
then you would need to specify user and password in the code.

```java
//...
p.setProperty("security.protocol", "SASL_PLAINTEXT");
p.setProperty("sasl.mechanism", "PLAIN");
//...

// Here we provide user/password from code, rather than an external file
// We dont need extranal file in this case.
p.setProperty("sasl.jaas.config",
  "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"alice\" password=\"alice-secret\";");

producer = new KafkaProducer<>(p);

consumer = new KafkaConsumer<>(p);
```

## Docs
* Kafka Security Documentation
  * https://kafka.apache.org/0110/documentation.html#security
* KIP-11 - Authorization Interface
  * https://cwiki.apache.org/confluence/display/KAFKA/KIP-11+-+Authorization+Interface
* Kafka Security Proposal
  * https://cwiki.apache.org/confluence/display/KAFKA/Security
* KAFKA-1682
  * https://issues.apache.org/jira/browse/KAFKA-1682
* Simple Authentication and Security Layer (SASL)
  * https://tools.ietf.org/html/rfc4422
* Salted Challenge Response Authentication Mechanism (SCRAM) SASL and GSS-API Mechanisms
  * https://tools.ietf.org/html/rfc5802
