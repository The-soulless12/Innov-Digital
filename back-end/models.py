from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base  # Ajoute cet import
from sqlalchemy.orm import relationship
from datetime import datetime

Base = declarative_base()  # Ceci permet de créer la base de modèles

class Document(Base):
    __tablename__ = "documents"

    id = Column(Integer, primary_key=True, index=True)
    filename = Column(String, nullable=False)
    uploader = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    keywords = Column(Text, nullable=False)
    uploaded_at = Column(DateTime, default=datetime.utcnow)
    
    # Relation avec DocumentVersion
    versions = relationship("DocumentVersion", back_populates="document")


class DocumentVersion(Base):
    __tablename__ = "document_versions"

    id = Column(Integer, primary_key=True, index=True)
    document_id = Column(Integer, ForeignKey('documents.id'), nullable=False)
    version_number = Column(Integer, nullable=False)
    filename = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    keywords = Column(Text, nullable=False)
    uploaded_at = Column(DateTime, default=datetime.utcnow)

    # Relation avec Document
    document = relationship("Document", back_populates="versions")
