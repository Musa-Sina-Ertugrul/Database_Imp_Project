import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import threading
import logging
import time
import random
from numba import jit

LOOK_UP_TABLE = set([
    "add",
    "delete",
    "get",
])

class WrongCommand(RuntimeError):
    logging.error(f"WrongCommand Exception: {RuntimeError}")

class ConnectionFailure(RuntimeError):
    logging.error(f"ConnectionFailure Exception: {RuntimeError}")

@jit(forceobj=True,nogil=True)
def booting()-> None:
    for i in range( 7 + random.randint(0,7)):
        print("*\t"*i)
        time.sleep(0.5)

def get(cur,raw_info_list:list):
    tweet_id = raw_info_list[0].strip()
    cur.execute(f"SELECT * FROM tweets WHERE tweet_id = {tweet_id};")
    result = cur.fetchone()
    print(result) if result else print("Tweet not found.")

def add(cur,raw_info_list:list):
    tweet_id, created_at, text, retweet_count, tweet_source = map(str.strip, raw_info_list)
    cur.execute(f"""
        INSERT INTO tweets (tweet_id, created_at, text, retweet_count, tweet_source)
        VALUES ({tweet_id}, '{created_at}', '{text}', {retweet_count}, '{tweet_source}');
    """)
    print("Tweet added successfully.")

def delete(cur,raw_info_list:list):
    tweet_id = raw_info_list[0].strip()
    cur.execute(f"DELETE FROM tweets WHERE tweet_id = {tweet_id};")
    print("Tweet deleted successfully.")

def template_check(func,cur)->True:
    raw_info: str = input("Enter info for query \n")
    try:
        raw_info_list = raw_info.split(",")
    except _ :
        logging.exception(WrongCommand(f" {WrongCommand.__name__} : Undefined query info\n"),exc_info=False,stack_info=False)
        return False
    if len(raw_info_list)<3: # TODO: Update here according to your db
        logging.exception(WrongCommand(f" {WrongCommand.__name__} : Undefined query info\n"),exc_info=False,stack_info=False)
        return False
    try:
        func(cur,raw_info_list)
    except WrongCommand:
        logging.exception(WrongCommand(f" {WrongCommand.__name__} : Undefined query info\n"),exc_info=False,stack_info=False)
        return False
    return True
if __name__ == "__main__":

    print("Welcome to NeshFlix")
    print("System is booting")

    T : threading.Thread = threading.Thread(target=booting)
    T.start()

    try:
        conn=psycopg2.connect(database="twiXter",user="enter_username",password="enter_password")
    except ConnectionError or ConnectionFailure or psycopg2.OperationalError:
        T.join()
        logging.exception(ConnectionFailure(f" {ConnectionFailure.__name__} Connection Error"),exc_info=False,stack_info=False)
        exit(1)

    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cur=conn.cursor()

    T.join()

    print("")
    print("System booted succesfully\n")

    while True:
        time.sleep(1)
        action : str = input("Choose action: \n")
        if action in LOOK_UP_TABLE:
            match action:
                case "add":
                    if template_check(add,cur):
                        print("\nQuery succesed")
                    continue
                case "delete":
                    if template_check(delete,cur):
                        print("\nQuery succesed")
                    continue
                case "get":
                    if template_check(get,cur):
                        print("\nQuery succesed")
                    continue
                case _ :
                    logging.exception(WrongCommand(f" {WrongCommand.__name__} : Undefined command\n"),exc_info=False,stack_info=False)
        else:
            logging.warning("Your command is not in lookup table\nLookup table commands: \n\t* add\n\t* delete\n\t* get")
