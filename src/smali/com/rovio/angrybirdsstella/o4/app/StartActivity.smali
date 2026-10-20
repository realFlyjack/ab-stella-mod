.class public Lcom/rovio/angrybirdsstella/o4/app/StartActivity;
.super Landroid/app/Activity;
.source "StartActivity.java"


# instance fields
.field private assetsData:Ljava/lang/String;

.field private assetsObb:Ljava/lang/String;

.field private da:Ljava/lang/String;

.field private fileName:Ljava/lang/String;

.field private key:Ljava/lang/String;

.field private localProgressDialog:Landroid/app/ProgressDialog;

.field mHandler:Landroid/os/Handler;

.field private noticeMsg:Ljava/lang/String;

.field private noticeTitle:Ljava/lang/String;

.field private once:Z

.field private pack:Ljava/lang/String;

.field private sd:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 24
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 26
    const-string v0, "ccdata"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->fileName:Ljava/lang/String;

    .line 27
    const-string v0, "state"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->key:Ljava/lang/String;

    .line 28
    const-string v0, "\u6e38\u620f\u63d0\u793a"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->noticeTitle:Ljava/lang/String;

    .line 29
    const-string v0, "\u7b2c\u4e00\u6b21\u8fdb\u5165\u9700\u8981\u89e3\u538b\u6570\u636e\uff0c\u8bf7\u7a0d\u540e..."

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->noticeMsg:Ljava/lang/String;

    .line 30
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->once:Z

    .line 32
    const-string v0, "$$Da"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->da:Ljava/lang/String;

    .line 33
    const-string v0, "$$Sd"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->sd:Ljava/lang/String;

    .line 34
    const-string v0, "$$pack"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->pack:Ljava/lang/String;

    .line 36
    const-string v0, "data.cfbe"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->assetsData:Ljava/lang/String;

    .line 37
    const-string v0, "obb.cfbe"

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->assetsObb:Ljava/lang/String;

    .line 40
    new-instance v0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity$1;

    invoke-direct {v0, p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity$1;-><init>(Lcom/rovio/angrybirdsstella/o4/app/StartActivity;)V

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->mHandler:Landroid/os/Handler;

    .line 24
    return-void
.end method

.method static synthetic access$0(Lcom/rovio/angrybirdsstella/o4/app/StartActivity;)Ljava/lang/String;
    .locals 1

    .prologue
    .line 26
    iget-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->fileName:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$1(Lcom/rovio/angrybirdsstella/o4/app/StartActivity;)Ljava/lang/String;
    .locals 1

    .prologue
    .line 27
    iget-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->key:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$2(Lcom/rovio/angrybirdsstella/o4/app/StartActivity;)V
    .locals 0

    .prologue
    .line 52
    invoke-direct {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->startWelcome()V

    return-void
.end method

.method static synthetic access$3(Lcom/rovio/angrybirdsstella/o4/app/StartActivity;)V
    .locals 0

    .prologue
    .line 104
    invoke-direct {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->ccplaydata()V

    return-void
.end method

.method private ccplaydata()V
    .locals 2

    .prologue
    .line 105
    new-instance v0, Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->da:Ljava/lang/String;

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->pack:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->assetsData:Ljava/lang/String;

    invoke-direct {p0, v0, v1}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->copyfile(Ljava/lang/String;Ljava/lang/String;)V

    .line 106
    new-instance v0, Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->sd:Ljava/lang/String;

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->assetsObb:Ljava/lang/String;

    invoke-direct {p0, v0, v1}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->copyfile(Ljava/lang/String;Ljava/lang/String;)V

    .line 107
    return-void
.end method

.method private copyfile(Ljava/lang/String;Ljava/lang/String;)V
    .locals 17
    .param p1, "s1"    # Ljava/lang/String;
    .param p2, "s2"    # Ljava/lang/String;

    .prologue
    .line 110
    invoke-virtual/range {p0 .. p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v4

    .line 111
    .local v4, "localAssetManager":Landroid/content/res/AssetManager;
    invoke-virtual/range {p0 .. p1}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    .line 112
    .local v14, "str2":Ljava/lang/String;
    new-instance v13, Ljava/io/File;

    invoke-direct {v13, v14}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 113
    .local v13, "path":Ljava/io/File;
    invoke-virtual {v13}, Ljava/io/File;->exists()Z

    move-result v15

    if-nez v15, :cond_0

    .line 114
    invoke-virtual {v13}, Ljava/io/File;->mkdirs()Z

    .line 117
    :cond_0
    :try_start_0
    move-object/from16 v0, p2

    invoke-virtual {v4, v0}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v9

    .line 118
    .local v9, "localInputStream":Ljava/io/InputStream;
    new-instance v12, Ljava/util/zip/ZipInputStream;

    invoke-direct {v12, v9}, Ljava/util/zip/ZipInputStream;-><init>(Ljava/io/InputStream;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 119
    .local v12, "localZipInputStream":Ljava/util/zip/ZipInputStream;
    const/4 v10, 0x0

    .line 123
    :cond_1
    :goto_0
    :try_start_1
    invoke-virtual {v12}, Ljava/util/zip/ZipInputStream;->getNextEntry()Ljava/util/zip/ZipEntry;

    move-result-object v11

    .line 124
    .local v11, "localZipEntry":Ljava/util/zip/ZipEntry;
    if-nez v11, :cond_2

    .line 125
    invoke-virtual {v12}, Ljava/util/zip/ZipInputStream;->close()V

    .line 165
    .end local v9    # "localInputStream":Ljava/io/InputStream;
    .end local v11    # "localZipEntry":Ljava/util/zip/ZipEntry;
    .end local v12    # "localZipInputStream":Ljava/util/zip/ZipInputStream;
    :goto_1
    return-void

    .line 128
    .restart local v9    # "localInputStream":Ljava/io/InputStream;
    .restart local v11    # "localZipEntry":Ljava/util/zip/ZipEntry;
    .restart local v12    # "localZipInputStream":Ljava/util/zip/ZipInputStream;
    :cond_2
    new-instance v8, Ljava/io/File;

    new-instance v15, Ljava/lang/StringBuilder;

    invoke-static {v14}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v16

    invoke-direct/range {v15 .. v16}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v11}, Ljava/util/zip/ZipEntry;->getName()Ljava/lang/String;

    move-result-object v16

    invoke-virtual/range {v15 .. v16}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v15

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v15

    invoke-direct {v8, v15}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 129
    .local v8, "localFile":Ljava/io/File;
    invoke-virtual {v8}, Ljava/io/File;->exists()Z

    move-result v15

    if-nez v15, :cond_1

    .line 131
    invoke-virtual {v11}, Ljava/util/zip/ZipEntry;->isDirectory()Z

    move-result v15

    if-eqz v15, :cond_3

    .line 132
    invoke-virtual {v8}, Ljava/io/File;->mkdirs()Z
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    .line 156
    .end local v8    # "localFile":Ljava/io/File;
    .end local v11    # "localZipEntry":Ljava/util/zip/ZipEntry;
    :catch_0
    move-exception v7

    .line 158
    .local v7, "localException2":Ljava/lang/Exception;
    :try_start_2
    invoke-virtual {v7}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_1

    .line 161
    .end local v7    # "localException2":Ljava/lang/Exception;
    .end local v9    # "localInputStream":Ljava/io/InputStream;
    .end local v12    # "localZipInputStream":Ljava/util/zip/ZipInputStream;
    :catch_1
    move-exception v6

    .line 163
    .local v6, "localException1":Ljava/lang/Exception;
    invoke-virtual {v6}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1

    .line 135
    .end local v6    # "localException1":Ljava/lang/Exception;
    .restart local v8    # "localFile":Ljava/io/File;
    .restart local v9    # "localInputStream":Ljava/io/InputStream;
    .restart local v11    # "localZipEntry":Ljava/util/zip/ZipEntry;
    .restart local v12    # "localZipInputStream":Ljava/util/zip/ZipInputStream;
    :cond_3
    const/16 v15, 0x800

    :try_start_3
    new-array v1, v15, [B

    .line 136
    .local v1, "arrayOfByte":[B
    new-instance v2, Ljava/io/File;

    invoke-virtual {v8}, Ljava/io/File;->getParent()Ljava/lang/String;

    move-result-object v15

    invoke-direct {v2, v15}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 137
    .local v2, "files":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v15

    if-nez v15, :cond_4

    .line 138
    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    .line 140
    :cond_4
    new-instance v5, Ljava/io/BufferedOutputStream;

    new-instance v15, Ljava/io/FileOutputStream;

    invoke-direct {v15, v8}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v16, 0x800

    move/from16 v0, v16

    invoke-direct {v5, v15, v0}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;I)V

    .line 142
    .local v5, "localBufferedOutputStream":Ljava/io/BufferedOutputStream;
    :goto_2
    const/4 v15, 0x0

    const/16 v16, 0x800

    move/from16 v0, v16

    invoke-virtual {v12, v1, v15, v0}, Ljava/util/zip/ZipInputStream;->read([BII)I

    move-result v3

    .line 143
    .local v3, "i":I
    const/4 v15, -0x1

    if-ne v3, v15, :cond_5

    .line 144
    invoke-virtual {v5}, Ljava/io/BufferedOutputStream;->flush()V

    .line 145
    invoke-virtual {v5}, Ljava/io/BufferedOutputStream;->close()V

    .line 146
    move-object v10, v5

    .line 147
    .local v10, "localObject2":Ljava/io/BufferedOutputStream;
    goto :goto_0

    .line 149
    .end local v10    # "localObject2":Ljava/io/BufferedOutputStream;
    :cond_5
    const/4 v15, 0x0

    invoke-virtual {v5, v1, v15, v3}, Ljava/io/BufferedOutputStream;->write([BII)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    goto :goto_2
.end method

.method private startWelcome()V
    .locals 2

    .prologue
    .line 53
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/rovio/fusion/App;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 54
    .local v0, "it":Landroid/content/Intent;
    invoke-virtual {p0, v0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->startActivity(Landroid/content/Intent;)V

    .line 55
    invoke-virtual {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->finish()V

    .line 56
    return-void
.end method

.method private overrideGiftConfig()V
    .locals 6

    :try_start_0
    invoke-virtual {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getFilesDir()Ljava/io/File;

    move-result-object v0

    new-instance v1, Ljava/io/File;

    const-string v2, "assets_service"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    new-instance v0, Ljava/io/File;

    const-string v2, "unlocked_gift_bird_skins.dat"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v1

    const-string v2, "gift_override.dat"

    invoke-virtual {v1, v2}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v1

    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v3, 0x400

    new-array v3, v3, [B

    :goto_0
    invoke-virtual {v1, v3}, Ljava/io/InputStream;->read([B)I

    move-result v4

    const/4 v5, -0x1

    if-ne v4, v5, :cond_0

    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    return-void

    :cond_0
    const/4 v5, 0x0

    invoke-virtual {v2, v3, v5, v4}, Ljava/io/FileOutputStream;->write([BII)V

    goto :goto_0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    return-void
.end method

.method private overrideCloudConfig()V
    .locals 6

    :try_start_0
    invoke-virtual {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getFilesDir()Ljava/io/File;

    move-result-object v0

    new-instance v1, Ljava/io/File;

    const-string v2, "assets_service"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    new-instance v0, Ljava/io/File;

    const-string v2, "cloud_configuration.dat"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v1

    const-string v2, "cloud_override.dat"

    invoke-virtual {v1, v2}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v1

    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v3, 0x400

    new-array v3, v3, [B

    :goto_0
    invoke-virtual {v1, v3}, Ljava/io/InputStream;->read([B)I

    move-result v4

    const/4 v5, -0x1

    if-ne v4, v5, :cond_0

    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    return-void

    :cond_0
    const/4 v5, 0x0

    invoke-virtual {v2, v3, v5, v4}, Ljava/io/FileOutputStream;->write([BII)V

    goto :goto_0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    return-void
.end method


# virtual methods
.method public getPath(Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p1, "path"    # Ljava/lang/String;

    .prologue
    .line 96
    const-string v0, ""

    .line 97
    .local v0, "ret":Ljava/lang/String;
    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->da:Ljava/lang/String;

    const-string v2, "/data/data"

    invoke-virtual {p1, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    .line 98
    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->sd:Ljava/lang/String;

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    .line 99
    iget-object v1, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->pack:Ljava/lang/String;

    invoke-virtual {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    .line 100
    return-object v0
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    const/4 v5, 0x0

    .line 60
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    invoke-direct {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->overrideGiftConfig()V

    invoke-direct {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->overrideCloudConfig()V

    .line 62
    :try_start_0
    invoke-virtual {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v3

    const-string v4, ""

    invoke-virtual {v3, v4}, Landroid/content/res/AssetManager;->list(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 63
    .local v1, "fileList":[Ljava/lang/String;
    invoke-static {v1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v2

    .line 64
    .local v2, "stringList":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->assetsData:Ljava/lang/String;

    invoke-interface {v2, v3}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->assetsObb:Ljava/lang/String;

    invoke-interface {v2, v3}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    .line 65
    invoke-direct {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->startWelcome()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 93
    .end local v1    # "fileList":[Ljava/lang/String;
    .end local v2    # "stringList":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :goto_0
    return-void

    .line 68
    :catch_0
    move-exception v0

    .line 69
    .local v0, "e":Ljava/io/IOException;
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    .line 71
    .end local v0    # "e":Ljava/io/IOException;
    :cond_0
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->fileName:Ljava/lang/String;

    invoke-virtual {p0, v3, v5}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v3

    iget-object v4, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->key:Ljava/lang/String;

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    iput-boolean v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->once:Z

    .line 72
    iget-boolean v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->once:Z

    if-eqz v3, :cond_1

    .line 73
    invoke-direct {p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->startWelcome()V

    goto :goto_0

    .line 75
    :cond_1
    new-instance v3, Landroid/app/ProgressDialog;

    invoke-direct {v3, p0}, Landroid/app/ProgressDialog;-><init>(Landroid/content/Context;)V

    iput-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    .line 76
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {v3, v5}, Landroid/app/ProgressDialog;->setProgress(I)V

    .line 77
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    const/4 v4, 0x1

    invoke-virtual {v3, v4}, Landroid/app/ProgressDialog;->setProgress(I)V

    .line 78
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    iget-object v4, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->noticeTitle:Ljava/lang/String;

    invoke-virtual {v3, v4}, Landroid/app/ProgressDialog;->setTitle(Ljava/lang/CharSequence;)V

    .line 79
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    iget-object v4, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->noticeMsg:Ljava/lang/String;

    invoke-virtual {v3, v4}, Landroid/app/ProgressDialog;->setMessage(Ljava/lang/CharSequence;)V

    .line 80
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {v3, v5}, Landroid/app/ProgressDialog;->setCancelable(Z)V

    .line 81
    iget-object v3, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {v3}, Landroid/app/ProgressDialog;->show()V

    .line 82
    new-instance v3, Lcom/rovio/angrybirdsstella/o4/app/StartActivity$2;

    invoke-direct {v3, p0}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity$2;-><init>(Lcom/rovio/angrybirdsstella/o4/app/StartActivity;)V

    .line 91
    invoke-virtual {v3}, Lcom/rovio/angrybirdsstella/o4/app/StartActivity$2;->start()V

    goto :goto_0
.end method

.method protected onDestroy()V
    .locals 1

    .prologue
    .line 169
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 170
    iget-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    if-eqz v0, :cond_0

    .line 171
    iget-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {v0}, Landroid/app/ProgressDialog;->dismiss()V

    .line 172
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/rovio/angrybirdsstella/o4/app/StartActivity;->localProgressDialog:Landroid/app/ProgressDialog;

    .line 174
    :cond_0
    return-void
.end method
