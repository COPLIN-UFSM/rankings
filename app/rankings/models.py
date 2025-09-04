# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.utils import timezone


# ------------------ #
# ---- Suporte ----- #
# ------------------ #

from django.db import models, connection

import re
from django.db import models

# precompiled patterns for \uXXXX (accept both \u and \U with 4 hex digits) and \xNN
_U4 = re.compile(r'\\[uU]([0-9a-fA-F]{4})')
_X2 = re.compile(r'\\x([0-9a-fA-F]{2})')


class UnicodeEscapedCharField(models.CharField):
    """
    - READ: If the DB value contains backslash escapes (e.g. \\u2019), decode them to real Unicode.
            Otherwise, return the value as-is (so 'País' stays 'País').
    - WRITE: Keep Latin-1 chars as-is; escape any non–Latin-1 char as \\uXXXX
             (so ’ → \\u2019, – → \\u2013) to satisfy the ISO-8859-1 DB.
    """
    def _decode_escapes(self, s: str) -> str:
        if not s or '\\' not in s:
            return s
        # decode \\uXXXX and \\xNN without touching normal characters
        s = _U4.sub(lambda m: chr(int(m.group(1), 16)), s)
        s = _X2.sub(lambda m: chr(int(m.group(1), 16)), s)
        return s

    def from_db_value(self, value, expression, connection):
        if value is None:
            return value
        return self._decode_escapes(value)

    def to_python(self, value):
        if value is None:
            return value
        if isinstance(value, str):
            # only decode if there are escapes; do NOT re-encode clean text
            return self._decode_escapes(value)
        return str(value)

    def get_prep_value(self, value):
        if value is None:
            return value
        # escape only the characters that Latin-1 cannot represent
        out = []
        for ch in str(value):
            try:
                ch.encode('latin-1')
                out.append(ch)
            except UnicodeEncodeError:
                out.append(f'\\u{ord(ch):04x}')
        return ''.join(out)


# ------------------ #
# ----- Países ----- #
# ------------------ #

class Continente(models.Model):
    list_display = ['nome_continente_portugues', 'nome_continente_ingles']

    id_continente = models.AutoField(db_column='ID_CONTINENTE', primary_key=True, blank=True, null=False)
    nome_portugues = UnicodeEscapedCharField('Nome (PT-BR)', max_length=512, db_column='NOME_CONTINENTE_PORTUGUES', blank=False, null=False)
    nome_ingles = UnicodeEscapedCharField('Nome (EN-US)', max_length=512, db_column='NOME_CONTINENTE_INGLES', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'R_CONTINENTES'
        
    def __str__(self):
        return self.nome_portugues


class Pais(models.Model):
    id_pais = models.AutoField(db_column='ID_PAIS', primary_key=True, verbose_name='País', blank=True, null=False)
    continente = models.ForeignKey(
        Continente, models.DO_NOTHING, db_column='ID_CONTINENTE', verbose_name='Continente', blank=False, null=False
    )
    nome_portugues = UnicodeEscapedCharField('Nome (PT-BR)', blank=False, null=False, max_length=512, db_column='NOME_PAIS_PORTUGUES')
    nome_ingles = UnicodeEscapedCharField('Nome (EN-US)', blank=True, null=True, max_length=512, db_column='NOME_PAIS_INGLES')

    class Meta:
        managed = False
        db_table = 'R_PAISES'
        verbose_name = 'País'
        verbose_name_plural = 'Países'

    def __str__(self):
        return self.nome_portugues


class TipoApelido(models.Model):
    id_tipo_apelido = models.AutoField(db_column='ID_TIPO_APELIDO', primary_key=True, blank=True, null=False)
    tipo_apelido = UnicodeEscapedCharField('Tipo Apelido', max_length=512, db_column='TIPO_APELIDO', blank=False, null=False)

    class Meta:
        managed = False
        db_table = 'R_PAISES_APELIDOS_TIPOS'
        verbose_name = 'Tipo Apelido'
        verbose_name_plural = 'Tipos Apelidos'

    def __str__(self):
        return self.tipo_apelido


class ApelidoDePais(models.Model):
    id_apelido = models.AutoField(db_column='ID_APELIDO_PAIS', primary_key=True, blank=True, null=False)
    tipo_apelido = models.ForeignKey(TipoApelido, models.DO_NOTHING, db_column='ID_TIPO_APELIDO', blank=False, null=False)
    apelido = UnicodeEscapedCharField('Apelido', db_column='APELIDO', max_length=512, blank=False, null=False)
    pais = models.ForeignKey(Pais, models.DO_NOTHING, db_column='ID_PAIS', blank=False, null=False)

    class Meta:
        managed = False
        db_table = 'R_PAISES_APELIDOS'
        verbose_name = 'Apelido'
        verbose_name_plural = 'Apelidos'

    def __str__(self):
        return self.apelido


class GrupoGeopolitico(models.Model):
    id_grupo_geopolitico = models.AutoField(db_column='ID_GRUPO_GEOPOLITICO', primary_key=True, blank=True, null=False)
    nome_portugues = UnicodeEscapedCharField('Nome (PT-BR)', db_column='NOME_GRUPO_PORTUGUES', max_length=512, blank=False, null=False)
    nome_ingles = UnicodeEscapedCharField('Nome (EN-US)', db_column='NOME_GRUPO_INGLES', max_length=512, blank=True, null=True)
    sigla = UnicodeEscapedCharField('Sigla', max_length=512, db_column='SIGLA', blank=True, null=True)
    paises = models.ManyToManyField(
        to=Pais,
        through='PaisesParaGruposGeopoliticos'
    )

    class Meta:
        managed = False
        db_table = 'R_GRUPOS_GEOPOLITICOS'
        verbose_name = 'Grupo geopolítico'
        verbose_name_plural = 'Grupos Geopolíticos'

    def __str__(self):
        return self.nome_portugues


class PaisesParaGruposGeopoliticos(models.Model):
    grupo_geopolitico = models.OneToOneField(
        GrupoGeopolitico, models.DO_NOTHING, db_column='ID_GRUPO_GEOPOLITICO',
        blank=True, null=False, verbose_name='Nome (PT-BR)'
    )
    pais = models.ForeignKey(
        Pais, models.DO_NOTHING, db_column='ID_PAIS', blank=True, null=False,
        verbose_name='Nome (PT-BR)'
    )

    pk = models.CompositePrimaryKey('grupo_geopolitico_id', 'pais_id')

    class Meta:
        managed = False
        db_table = 'R_PAISES_PARA_GRUPOS_GEOPOLITICOS'
        unique_together = (('grupo_geopolitico', 'pais'), )

    def __str__(self):
        return ''


# ------------------------- #
# ----- Universidades ----- #
# ------------------------- #

class IES(models.Model):
    cod_ies = models.AutoField('Código IES', db_column='COD_IES', primary_key=True, blank=False, null=False)
    sigla_ies = UnicodeEscapedCharField('Sigla', max_length=64, db_column='SIGLA_IES', blank=True, null=True)
    nome_ies = UnicodeEscapedCharField(
        'Nome (PT-BR)', max_length=512, db_column='NOME_IES', blank=False, null=False
    )

    class Meta:
        managed = False
        db_table = 'IES'
        verbose_name = 'Instituição de Ensino Superior'
        verbose_name_plural = 'Instituições de Ensino Superior'

    def __str__(self):
        return self.sigla_ies


class Universidade(models.Model):
    id_universidade = models.AutoField(db_column='ID_UNIVERSIDADE', primary_key=True, blank=True, null=False)

    cod_ies = models.IntegerField('Código IES', db_column='COD_IES', primary_key=False, blank=True, null=True)

    nome_portugues = UnicodeEscapedCharField(
        'Nome (PT-BR)', max_length=512, db_column='NOME_UNIVERSIDADE_PORTUGUES', blank=False, null=False
    )
    nome_ingles = UnicodeEscapedCharField(
        'Nome (EN-US)', max_length=512, db_column='NOME_UNIVERSIDADE_INGLES', blank=True, null=True
    )
    sigla = UnicodeEscapedCharField('Sigla', db_column='SIGLA', max_length=512, blank=True, null=True)
    pais_apelido = models.ForeignKey(
        ApelidoDePais, models.DO_NOTHING, db_column='ID_APELIDO_PAIS', verbose_name='País (apelido)',
        blank=False, null=False
    )

    @property
    def pais(self):
        return self.pais_apelido.pais.nome_portugues

    class Meta:
        managed = False
        db_table = 'R_UNIVERSIDADES'
        verbose_name = 'Universidade'
        verbose_name_plural = 'Universidades'

    def __str__(self):
        return self.nome_portugues


class ApelidoDeUniversidade(models.Model):
    id_apelido = models.AutoField(db_column='ID_APELIDO_UNIVERSIDADE', primary_key=True, blank=True, null=False)
    universidade = models.ForeignKey(Universidade, models.DO_NOTHING, db_column='ID_UNIVERSIDADE', blank=False, null=False)
    apelido = UnicodeEscapedCharField('Apelido', max_length=512, db_column='APELIDO', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'R_UNIVERSIDADES_APELIDOS'
        verbose_name = 'Apelido'
        verbose_name_plural = 'Apelidos'

    def __str__(self):
        return self.apelido


class GrupoDeUniversidades(models.Model):
    id_grupo_universidades = models.AutoField(
        db_column='ID_GRUPO_UNIVERSIDADES', primary_key=True, blank=True, null=False
    )
    nome_portugues = UnicodeEscapedCharField('Nome (PT-BR)', max_length=512, db_column='NOME_GRUPO_PORTUGUES', blank=False, null=False)
    nome_ingles = UnicodeEscapedCharField('Nome (EN-US)', max_length=512, db_column='NOME_GRUPO_INGLES', blank=True, null=True)

    universidades = models.ManyToManyField(
        to=Universidade,
        through='UniversidadesParaGrupos'
    )

    class Meta:
        managed = False
        db_table = 'R_UNIVERSIDADES_GRUPOS'
        verbose_name = 'Grupo de Universidades'
        verbose_name_plural = 'Grupos de Universidades'

    def __str__(self):
        return self.nome_portugues


class UniversidadesParaGrupos(models.Model):
    universidade = models.OneToOneField(
        Universidade, models.DO_NOTHING, db_column='ID_UNIVERSIDADE', blank=False, null=False,
        verbose_name='Universidade'
    )
    grupo_universidades = models.ForeignKey(
        GrupoDeUniversidades, models.DO_NOTHING, db_column='ID_GRUPO_UNIVERSIDADES', blank=False, null=False,
        verbose_name='Grupo de Universidades'
    )

    pk = models.CompositePrimaryKey('universidade_id', 'grupo_universidades_id')

    class Meta:
        managed = False
        db_table = 'R_UNIVERSIDADES_PARA_GRUPOS'
        unique_together = (('universidade', 'grupo_universidades'),)

    def __str__(self):
        return ''

# -------------------- #
# ----- Rankings ----- #
# -------------------- #


class Ranking(models.Model):
    id_ranking = models.AutoField(db_column='ID_RANKING', primary_key=True, blank=True, null=False)
    nome = UnicodeEscapedCharField('Nome', max_length=512, db_column='NOME_RANKING', unique=True, blank=False, null=False)

    class Meta:
        managed = False
        db_table = 'R_RANKINGS'
        verbose_name = 'Ranking'
        verbose_name_plural = 'Rankings'

    def __str__(self):
        return self.nome


class Pilar(models.Model):
    id_pilar = models.AutoField(db_column='ID_PILAR', primary_key=True, blank=True, null=False)
    ranking = models.ForeignKey(Ranking, models.DO_NOTHING, db_column='ID_RANKING', blank=False, null=False)
    nome_portugues = UnicodeEscapedCharField('Nome (PT-BR)', max_length=512, db_column='NOME_PILAR_PORTUGUES', blank=False, null=False)
    nome_ingles = UnicodeEscapedCharField('Nome (EN-US)', max_length=512, db_column='NOME_PILAR_INGLES', blank=True, null=True)
    descricao_portugues = UnicodeEscapedCharField('Descrição (PT-BR)', max_length=512, db_column='DESCRICAO_PILAR_PORTUGUES', blank=True, null=True)
    descricao_ingles = UnicodeEscapedCharField('Descrição (EN-US)', max_length=512, db_column='DESCRICAO_PILAR_INGLES', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'R_PILARES'
        verbose_name = 'Pilar'
        verbose_name_plural = 'Pilares'

    def __str__(self):
        return self.nome_portugues


class GrupoDePilares(models.Model):
    id_grupo_pilares = models.AutoField(db_column='ID_GRUPO_PILARES', primary_key=True, blank=True, null=False)
    nome_portugues = UnicodeEscapedCharField('Nome (PT-BR)', max_length=512, db_column='NOME_GRUPO_PORTUGUES', blank=False, null=False)
    nome_ingles = UnicodeEscapedCharField('Nome (EN-US)', max_length=512, db_column='NOME_GRUPO_INGLES', blank=True, null=True)
    pilares = models.ManyToManyField(
        to=Pilar,
        through='PilaresParaGrupos'
    )

    class Meta:
        managed = False
        db_table = 'R_PILARES_GRUPOS'
        verbose_name = 'Grupo de pilares'
        verbose_name_plural = 'Grupos de Pilares'

    def __str__(self):
        return self.nome_portugues


class PilaresParaGrupos(models.Model):
    pilar = models.OneToOneField(
        Pilar, models.DO_NOTHING, db_column='ID_PILAR', blank=False, null=False, verbose_name='Pilar'
    )
    grupo_pilares = models.ForeignKey(
        GrupoDePilares, models.DO_NOTHING, db_column='ID_GRUPO_PILARES', blank=False, null=False,
        verbose_name='Grupo de pilares'
    )

    pk = models.CompositePrimaryKey('pilar_id', 'grupo_pilares_id')

    class Meta:
        managed = False
        db_table = 'R_PILARES_PARA_GRUPOS'
        unique_together = (('pilar', 'grupo_pilares'), )
        ordering = ['grupo_pilares', 'pilar']

    def __str__(self):
        return ''


class PilarValor(models.Model):
    apelido_universidade = models.ForeignKey(
        ApelidoDeUniversidade, models.DO_NOTHING, db_column='ID_APELIDO_UNIVERSIDADE',
        blank=False, null=False
    )
    pilar = models.ForeignKey(
        Pilar, models.DO_NOTHING, db_column='ID_PILAR', verbose_name='Pilar', blank=False, null=False
    )
    ano = models.IntegerField(db_column='ANO', verbose_name='Ano', blank=False, null=False)
    valor_inicial = models.FloatField(db_column='VALOR_INICIAL', blank=True, null=True, verbose_name='Valor Inicial')
    valor_final = models.FloatField(db_column='VALOR_FINAL', blank=True, null=True, verbose_name='Valor Final')

    # pk = models.CompositePrimaryKey('apelido_universidade_id', 'pilar_id', 'ano')
    pk = models.CompositePrimaryKey('apelido_universidade', 'pilar', 'ano')

    @property
    def ranking(self):
        return self.pilar.ranking.id_ranking

    class Meta:
        managed = False
        db_table = 'R_PILARES_VALORES'
        verbose_name = 'Valor do Pilar'
        verbose_name_plural = 'Valores dos Pilares'
        unique_together = (('apelido_universidade', 'pilar', 'ano'), )

    def __str__(self):
        return f'{self.apelido_universidade} - {self.pilar} - {self.ano} - {self.valor_inicial} - {self.valor_final}'


class UltimaCarga(models.Model):
    id_ultima_carga = models.AutoField(db_column='ID_ULTIMA_CARGA', primary_key=True, blank=True, null=False)

    nome_tabela = UnicodeEscapedCharField(db_column='NOME_TABELA', max_length=128, unique=True, blank=False, null=False)
    dh_ultima_carga = models.DateTimeField(db_column='DH_ULTIMA_CARGA', default=timezone.now, blank=True, null=True)
    nome_ajustado = UnicodeEscapedCharField(db_column='NOME_AJUSTADO', max_length=200, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'ULTIMA_CARGA'
        verbose_name = "Última Carga"
        verbose_name_plural = "Últimas Cargas"

    def __str__(self):
        return f'{self.nome_tabela} - ({self.dh_ultima_carga})'