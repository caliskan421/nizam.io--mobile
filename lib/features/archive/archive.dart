/// archive özelliğinin açık yüzü: arşiv klasörleri, klasör ayrıntısı ve dosya önizleme. Başka feature'lar ve `app/` yalnız bu dosyayı
/// import eder (sınır kuralı B3).
library;

export 'application/archive_folders_controller.dart'
    show archiveFoldersControllerProvider;
export 'application/archive_nav_caption.dart' show archiveNavCaptionProvider;
export 'application/archive_providers.dart'
    show archiveRepositoryProvider, archiveScopeProvider;
export 'application/person_files_controller.dart'
    show personFilesControllerProvider;
export 'domain/archive.dart' show ArchiveScope, ArchiveRepository;
export 'domain/records.dart' show RecordFile, ArchiveAttachmentFilter;
export 'presentation/archive_folder_page.dart' show ArchiveFolderPage;
export 'presentation/archive_page.dart' show ArchivePage;
export 'presentation/open_archive_file.dart' show openArchiveFile;
export 'presentation/person_files.dart' show PersonFiles;
