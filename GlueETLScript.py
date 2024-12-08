# ETL Job Script that extracts and transforms a dataset from an S3 bucket folder using SQL, then writes it to a seperate folder meant to store the transformed data.

import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame

def sparkSqlQuery(glueContext, query, mapping, transformation_ctx) -> DynamicFrame:
    for alias, frame in mapping.items():
        frame.toDF().createOrReplaceTempView(alias)
    result = spark.sql(query)
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node Amazon S3
AmazonS3_node1733056369757 = glueContext.create_dynamic_frame.from_options(format_options={"quoteChar": "\"", "withHeader": True, "separator": ",", "optimizePerformance": False}, connection_type="s3", format="csv", connection_options={"paths": ["s3://easybuckets/healthcaredata/"], "recurse": True}, transformation_ctx="AmazonS3_node1733056369757")

# Transforming Dataset using SQL within AWS Glue
SqlQuery44 = '''
SELECT `patient id`,
SUBSTRING_INDEX(name, " ", 1) AS first_name,
SUBSTRING_INDEX(name, " ", -1) AS last_name,
age,
diagnosis,
treatment
FROM myDataSource
WHERE age > 40

'''
SQLQuery_node1733064367299 = sparkSqlQuery(glueContext, query = SqlQuery44, mapping = {"myDataSource":AmazonS3_node1733056369757}, transformation_ctx = "SQLQuery_node1733064367299")

# Creating Dataframe for SQL Query output above
dataframe = SQLQuery_node1733064367299.toDF()

dataframe = dataframe.repartition(1)

# Writing Transformed Dataframe data to S3 bucket
dataframe.write\
    .format("csv")\
    .option("quote", None)\
    .option("sep", ",")\
    .option("header", "True")\
    .mode("overwrite")\
    .save("s3://easybuckets/output_folder_ETL/")
                
job.commit()
