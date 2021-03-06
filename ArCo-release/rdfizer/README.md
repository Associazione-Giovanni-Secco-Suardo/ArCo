# RDFizer
This software implements the workflow for generating the Linked Open Data of the ArCo project.
The workflow relies on an XSLT processing that enables the conversion of the original dataset, which consists of a collection of XML catalogue records.
The XSLT sheet used by the software is the file `arco.xslt` and can be found in the folder `./src/main/resources/META-INF/xslt`.

### Requirements 
RDFizer is implemented as a Java 8 project with Maven support.

### Build
To build the software use Maven by typing the following command in the terminal having the root of the project as base folder:
```
$ mvn clean install
```

Once the build process fininshes, three executable JARs  can be found under the folder `target`, namely: `arco.rdfizer.jar`, `arco.rdfizer-xsltTransformer.jar`, and `arco.rdfizer-xsltTester.jar`.

If the XLST sheet is modified, then the software needs to be rebuilt again.

### JVM on Windows

When running rdfizer on Windows environment provide paramter  ``-Dfile.encoding=UTF-8`` to the JVM (cf. oifbaf's [comment](https://github.com/ICCD-MiBACT/ArCo/issues/75#issuecomment-620469221) on Issue #75).

### rdfizer Usage

The JAR named `arco.rdfizer.jar` transforms a collection of XML files into an RDF Knowledge Graph according to the XSTL transformations.
The command synopsis is the following:
```
$ java -Xmx2G -jar  arco.rdfizer.jar XML_FOLDER OUT_FOLDER
```
Where:
- the argument `XML_FOLDER`is the folder containing the collection of XML files to transform.
- the argument `OUT_FOLDER` is the folder where the Knowledge Graph will be stored.


**Note:**
- Please use the argument -Xmx2G in order to increase the size of the heap of (at least) 2 GB.
- Please use the naming convention ``arco-knowledge-graph-<KG_VERSION>`` for the ``OUT_FOLDER``.
- Once the RDFizer has terminated its processing, please remove temporary ttls folder with command ``rm -rf ttls/``.

#### Example

```
$ java -Xmx2G -jar arco.rdfizer.jar /path/to/input/XML_FOLDER /path/to/outpu/arco-knowledge-graph-1.0.0
```


### xsltTransformer Usage
The JAR named `arco.rdfizer-xsltTransformer.jar` can be executed in a terminal.
The command synopsis is the following:
```
$ java -jar arco.rdfizer-xsltTransformer.jar [OPTIONS] XML_FILE
```
Where the argument `XML_FILE` must be replaced with the path of the actual XML that needs to be converted to RDF.
The options are the following:
 - -o,--output <file>:  it allows to specify a file to use as the target destination for the output RDF generated by the application;
 - -s,--syntax <string>: it allows to specify the RDF syntax to use for the serialisation of the output. Acceptable values are RDF/XML, TURTLE, N-TRIPLES, JSON-LD, RDF/JSON, and N3. If no explicit value is specified, then the default syntax is TURTLE.

#### Example
The following command converts the XML catalogue record named `ICCD10006679.xml` to RDF. Additionally, it saves the resulting RDF to the file named `ICCD10006679.jsonld` by using the JSON-LD syntax.
```
$ java -jar arco.rdfizer-0.1.jar -s JSON-LD ICCD10006679.xml
```

### xsltTester Usage

Test cases for the RDFizer can be provided as a single CSV file. 
A row of the CSV file represents a test case where: the first colunmn of the row is the absolute path of the input XML file and the second column is the absolute path of the expected RDF file.

```
/path/to/test/folder/ICCD2234971.xml,/path/to/test/folder/ICCD2234971.ttl
/path/to/test/folder/ICCD2234972.xml,/path/to/test/folder/ICCD2234972.ttl
/path/to/test/folder/ICCD2234973.xml,/path/to/test/folder/ICCD2234973.ttl
```

The test case is passed when the RDF file generated by the RDFizer using the XML as input is isomorphic to the RDF file provided. 

#### Running test cases
The JAR named `arco.rdfizer-xsltTester.jar` can be executed in a terminal.
The command synopsis is the following:
```
$ java -jar arco.rdfizer-xsltTester.jar [-v] CSV_PATH
```
Where the argument `CSV_PATH` must be replaced with the path of the actual CSV file describing the test cases.
The parameter -v makes  the arco.rdfizer-xsltTester print (in case of a failed test) the difference between the generated RDF file and the expected RDF file, and viceversa.  


#### Example

The following command executes the test cases contained in the CSV file at path `/path/to/test/folder/testcases.csv`.
```
$ java -jar arco.rdfizer-xsltTester.jar /path/to/test/folder/testcases.csv
```
