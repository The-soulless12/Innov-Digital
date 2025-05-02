# create_db.py
from sqlalchemy import create_engine
from models import Base

engine = create_engine("sqlite:///db.sqlite3")
Base.metadata.create_all(bind=engine)
print("Base de données créée.")
