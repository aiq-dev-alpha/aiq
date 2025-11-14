import { Component, OnInit, ViewChild } from '@angular/core';
import {
  IonContent,
  IonInfiniteScroll,
  IonRefresher,
  AlertController,
  ToastController,
  ActionSheetController,
  ModalController,
  LoadingController
} from '@ionic/angular';
import { formatDistanceToNow } from 'date-fns';

interface Article {
  id: string;
  title: string;
  summary: string;
  imageUrl: string;
  author: string;
  publishDate: Date;
  readTime: number;
  tags: string[];
  isBookmarked: boolean;
}

@Component({
  selector: 'app-article-list',
  templateUrl: './article-list.page.html',
  styleUrls: ['./article-list.page.scss']
})
export class ArticleListPage implements OnInit {
  @ViewChild(IonContent, { static: false }) content!: IonContent;
  @ViewChild(IonInfiniteScroll, { static: false }) infiniteScroll!: IonInfiniteScroll;
  @ViewChild(IonRefresher, { static: false }) refresher!: IonRefresher;

  articles: Article[] = [];
  filteredArticles: Article[] = [];
  loading = true;
  hasMore = true;
  page = 1;
  searchText = '';
  selectedCategory = 'All';

  readonly categories = ['All', 'Technology', 'Business', 'Sports', 'Health', 'Entertainment'];

  constructor(
    private alertCtrl: AlertController,
    private toastCtrl: ToastController,
    private actionSheetCtrl: ActionSheetController,
    private modalCtrl: ModalController,
    private loadingCtrl: LoadingController
  ) {}

  ngOnInit() {
    this.loadArticles();
  }

  // Generate sample articles
  private generateArticles(pageNum: number): Article[] {
    const titles = [
      'The Future of Artificial Intelligence in Healthcare',
      'Climate Change: What We Can Do Today',
      'Breaking: Major Tech Company Announces Revolutionary Product',
      'The Rise of Remote Work: Challenges and Opportunities',
      'Space Exploration: Humanity\'s Next Frontier',
      'Sustainable Energy Solutions for Tomorrow',
      'The Impact of Social Media on Mental Health',
      'Cryptocurrency: Understanding the Digital Economy',
      'Machine Learning Transforms Medical Diagnosis',
      'The Evolution of Electric Vehicles'
    ];

    const authors = ['Dr. Sarah Johnson', 'Michael Chen', 'Emma Rodriguez', 'Prof. David Kim', 'Lisa Thompson'];
    const tags = [
      ['technology', 'ai', 'healthcare'],
      ['environment', 'climate', 'sustainability'],
      ['business', 'technology', 'innovation'],
      ['workplace', 'productivity', 'lifestyle'],
      ['space', 'exploration', 'science'],
      ['energy', 'environment', 'technology'],
      ['health', 'social media', 'psychology'],
      ['finance', 'cryptocurrency', 'technology'],
      ['healthcare', 'ai', 'innovation'],
      ['automotive', 'technology', 'environment']
    ];

    return Array.from({ length: 20 }, (_, index) => {
      const globalIndex = (pageNum - 1) * 20 + index;
      const titleIndex = globalIndex % titles.length;

      return {
        id: `article_${globalIndex}`,
        title: titles[titleIndex],
        summary: `This comprehensive article explores the latest developments and insights in ${titles[titleIndex].toLowerCase()}, providing readers with expert analysis and actionable information.`,
        imageUrl: `https://picsum.photos/400/250?random=${globalIndex}`,
        author: authors[globalIndex % authors.length],
        publishDate: new Date(Date.now() - globalIndex * 24 * 60 * 60 * 1000),
        readTime: 3 + (globalIndex % 8),
        tags: tags[titleIndex],
        isBookmarked: false
      };
    });
  }

  // Load initial articles
  async loadArticles() {
    const loading = await this.loadingCtrl.create({
      message: 'Loading articles...'
    });
    await loading.present();

    try {
      // Simulate API call
      await this.delay(1000);

      const newArticles = this.generateArticles(1);
      this.articles = newArticles;
      this.page = 2;
      this.filterArticles();
    } catch (error) {
      await this.showErrorToast('Failed to load articles');
    } finally {
      this.loading = false;
      await loading.dismiss();
    }
  }

  // Load more articles
  async loadMoreArticles(event: any) {
    try {
      await this.delay(500);

      const newArticles = this.generateArticles(this.page);
      this.articles = [...this.articles, ...newArticles];
      this.page++;

      if (this.page > 5) {
        this.hasMore = false;
      }

      this.filterArticles();
    } catch (error) {
      await this.showErrorToast('Failed to load more articles');
    } finally {
      event.target.complete();
    }
  }

  // Refresh articles
  async refreshArticles(event: any) {
    try {
      this.page = 1;
      this.hasMore = true;

      await this.delay(1000);

      const newArticles = this.generateArticles(1);
      this.articles = newArticles;
      this.page = 2;
      this.filterArticles();

      await this.showSuccessToast('Articles refreshed');
    } catch (error) {
      await this.showErrorToast('Failed to refresh articles');
    } finally {
      event.target.complete();
    }
  }

  // Filter articles
  filterArticles() {
    this.filteredArticles = this.articles.filter(article => {
      const matchesSearch = !this.searchText ||
        article.title.toLowerCase().includes(this.searchText.toLowerCase()) ||
        article.summary.toLowerCase().includes(this.searchText.toLowerCase());

      const matchesCategory = this.selectedCategory === 'All' ||
        article.tags.some(tag => tag.toLowerCase() === this.selectedCategory.toLowerCase());

      return matchesSearch && matchesCategory;
    });
  }

  // Search articles
  onSearchChange(event: any) {
    this.searchText = event.detail.value;
    this.filterArticles();
  }

  // Clear search
  clearSearch() {
    this.searchText = '';
    this.filterArticles();
  }

  // Select category
  selectCategory(category: string) {
    this.selectedCategory = category;
    this.filterArticles();
  }

  // Toggle bookmark
  async toggleBookmark(article: Article) {
    article.isBookmarked = !article.isBookmarked;

    const message = article.isBookmarked ? 'Article bookmarked' : 'Bookmark removed';
    await this.showSuccessToast(message);
  }

  // Open article
  openArticle(article: Article) {
    // Navigation logic would go here
    console.log('Opening article:', article.id);
  }

  // Show article options
  async showArticleOptions(article: Article) {
    const actionSheet = await this.actionSheetCtrl.create({
      header: 'Article Options',
      buttons: [
        {
          text: 'Read Article',
          icon: 'document-text-outline',
          handler: () => {
            this.openArticle(article);
          }
        },
        {
          text: article.isBookmarked ? 'Remove Bookmark' : 'Bookmark',
          icon: article.isBookmarked ? 'bookmark' : 'bookmark-outline',
          handler: () => {
            this.toggleBookmark(article);
          }
        },
        {
          text: 'Share',
          icon: 'share-outline',
          handler: () => {
            this.shareArticle(article);
          }
        },
        {
          text: 'Report',
          icon: 'flag-outline',
          role: 'destructive',
          handler: () => {
            this.reportArticle(article);
          }
        },
        {
          text: 'Cancel',
          icon: 'close',
          role: 'cancel'
        }
      ]
    });
    await actionSheet.present();
  }

  // Share article
  async shareArticle(article: Article) {
    if (navigator.share) {
      try {
        await navigator.share({
          title: article.title,
          text: article.summary,
          url: `https://example.com/article/${article.id}`
        });
      } catch (error) {
        console.log('Error sharing:', error);
      }
    } else {
      await this.showInfoToast('Share functionality not available');
    }
  }

  // Report article
  async reportArticle(article: Article) {
    const alert = await this.alertCtrl.create({
      header: 'Report Article',
      message: 'Why are you reporting this article?',
      inputs: [
        {
          name: 'reason',
          type: 'radio',
          label: 'Inappropriate content',
          value: 'inappropriate'
        },
        {
          name: 'reason',
          type: 'radio',
          label: 'Spam',
          value: 'spam'
        },
        {
          name: 'reason',
          type: 'radio',
          label: 'Misleading information',
          value: 'misleading'
        },
        {
          name: 'reason',
          type: 'radio',
          label: 'Copyright violation',
          value: 'copyright'
        }
      ],
      buttons: [
        {
          text: 'Cancel',
          role: 'cancel'
        },
        {
          text: 'Report',
          handler: (data) => {
            this.showSuccessToast('Article reported successfully');
          }
        }
      ]
    });
    await alert.present();
  }

  // Show sort options
  async showSortOptions() {
    const actionSheet = await this.actionSheetCtrl.create({
      header: 'Sort Articles',
      buttons: [
        {
          text: 'By Date (Newest First)',
          icon: 'calendar-outline',
          handler: () => {
            this.sortArticles('date');
          }
        },
        {
          text: 'By Read Time',
          icon: 'time-outline',
          handler: () => {
            this.sortArticles('readTime');
          }
        },
        {
          text: 'By Title (A-Z)',
          icon: 'text-outline',
          handler: () => {
            this.sortArticles('title');
          }
        },
        {
          text: 'Cancel',
          icon: 'close',
          role: 'cancel'
        }
      ]
    });
    await actionSheet.present();
  }

  // Sort articles
  sortArticles(sortBy: string) {
    switch (sortBy) {
      case 'date':
        this.articles.sort((a, b) => new Date(b.publishDate).getTime() - new Date(a.publishDate).getTime());
        break;
      case 'readTime':
        this.articles.sort((a, b) => a.readTime - b.readTime);
        break;
      case 'title':
        this.articles.sort((a, b) => a.title.localeCompare(b.title));
        break;
    }
    this.filterArticles();
    this.showSuccessToast('Articles sorted');
  }

  // Navigate to bookmarks
  goToBookmarks() {
    // Navigation logic would go here
    console.log('Navigate to bookmarks');
  }

  // Format date
  formatDate(date: Date): string {
    return formatDistanceToNow(new Date(date), { addSuffix: true });
  }

  // Get author initials
  getAuthorInitials(author: string): string {
    return author.split(' ').map(name => name.charAt(0)).join('').toUpperCase();
  }

  // Utility methods
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  private async showSuccessToast(message: string) {
    const toast = await this.toastCtrl.create({
      message,
      duration: 2000,
      color: 'success',
      position: 'bottom'
    });
    await toast.present();
  }

  private async showErrorToast(message: string) {
    const toast = await this.toastCtrl.create({
      message,
      duration: 3000,
      color: 'danger',
      position: 'bottom'
    });
    await toast.present();
  }

  private async showInfoToast(message: string) {
    const toast = await this.toastCtrl.create({
      message,
      duration: 2000,
      color: 'medium',
      position: 'bottom'
    });
    await toast.present();
  }
}